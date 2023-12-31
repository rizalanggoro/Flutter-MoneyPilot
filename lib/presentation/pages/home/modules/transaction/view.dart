import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_pilot/core/enums/sort_transaction_by.dart';
import 'package:money_pilot/core/enums/sort_type.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/core/route/params/transaction_detail.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/models/transaction.dart';
import 'package:money_pilot/domain/usecases/filter_transaction_by_category_type.dart';
import 'package:money_pilot/domain/usecases/read_category_by_key.dart';
import 'package:money_pilot/domain/usecases/sort_transaction.dart';
import 'package:money_pilot/presentation/cubit/category/cubit.dart';
import 'package:money_pilot/presentation/cubit/transaction/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class HomeTransaction extends StatefulWidget {
  const HomeTransaction({super.key});

  @override
  State<HomeTransaction> createState() => _HomeTransactionState();
}

class _HomeTransactionState extends State<HomeTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar,
      body: _content,
    );
  }

  get _appbar => AppBar(
        title: const Text('Transaksi'),
        actions: [
          IconButton(
            onPressed: () => _showBottomSheetSorting(),
            icon: const Icon(Icons.sort_rounded),
          ),
          const SizedBox(width: 16),
        ],
      );

  get _content => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: BlocBuilder<HomeTransactionCubit, HomeTransactionState>(
                bloc: context.read<HomeTransactionCubit>(),
                buildWhen: (previous, current) =>
                    current.type == StateType.filterCategoryTypeChanged,
                builder: (context, state) {
                  return SegmentedButton<FilterCategoryType>(
                    showSelectedIcon: false,
                    emptySelectionAllowed: false,
                    multiSelectionEnabled: false,
                    onSelectionChanged: (set) => context
                        .read<HomeTransactionCubit>()
                        .changeFilterCategoryType(
                          categoryType: set.first,
                        ),
                    segments: const [
                      ButtonSegment(
                        value: FilterCategoryType.all,
                        label: Text('Semua'),
                      ),
                      ButtonSegment(
                        value: FilterCategoryType.income,
                        label: Text('Pemasukan'),
                      ),
                      ButtonSegment(
                        value: FilterCategoryType.expense,
                        label: Text('Pengeluaran'),
                      ),
                    ],
                    selected: {state.filterCategoryType},
                  );
                },
              ),
            ),
            Builder(
              builder: (context) {
                final categoryState = context.watch<CategoryCubit>().state;
                final transactionState =
                    context.watch<CubitTransaction>().state;
                context.select<HomeTransactionCubit, FilterCategoryType>(
                    (value) => value.state.filterCategoryType);
                context.select<HomeTransactionCubit, SortTransactionBy>(
                    (value) => value.state.sortTransactionBy);
                context.select<HomeTransactionCubit, SortType>(
                    (value) => value.state.sortTransactionType);

                if (transactionState.status.isLoading ||
                    categoryState.status.isLoading) {
                  return const Center(
                    child: Text('Memuat data transaksi'),
                  );
                }

                return FutureBuilder(
                  future: context
                      .read<HomeTransactionCubit>()
                      .filterTransactionByCategoryType(
                        categories: categoryState.categories,
                        transactions: transactionState.transactions,
                      ),
                  builder: (context, snapshot) {
                    List<Transaction> transactions = [];
                    if (snapshot.hasData) {
                      transactions = snapshot.data ?? [];
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => _listItemTransaction(
                        transaction: transactions[index],
                      ),
                      itemCount: transactions.length,
                    );
                  },
                );
              },
            ),
          ],
        ),
      );

  _listItemTransaction({
    required Transaction transaction,
  }) =>
      FutureBuilder(
        future: context
            .read<HomeTransactionCubit>()
            .readCategoryByKey(key: transaction.categoryKey ?? -1),
        builder: (context, snapshot) {
          Category? category;
          if (snapshot.hasData) {
            category = snapshot.data;
          }

          return ListTile(
            leading: CircleAvatar(
              child: Icon(
                category == null
                    ? Icons.remove_rounded
                    : (category.type == CategoryType.income
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded),
              ),
            ),
            title: Text(category?.name ?? 'Tidak ada kategori'),
            subtitle: Text(
              DateFormat('EEE, dd MMM yy').format(
                transaction.dateTime,
              ),
            ),
            trailing: Text(
              NumberFormat.currency(locale: 'id').format(transaction.amount),
            ),
            onTap: () => context.push(
              Routes.transactionDetail,
              extra: RouteParamTransactionDetail(
                transaction: transaction,
              ),
            ),
          );
        },
      );

  void _showBottomSheetSorting() => showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Urutkan berdasarkan',
                style: Utils.textTheme(context).titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            BlocBuilder<HomeTransactionCubit, HomeTransactionState>(
              bloc: this.context.read<HomeTransactionCubit>(),
              buildWhen: (previous, current) =>
                  current.type == StateType.sortByChanged,
              builder: (context, state) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    RadioListTile<SortTransactionBy>(
                      value: SortTransactionBy.amount,
                      groupValue: state.sortTransactionBy,
                      onChanged: (_) => this
                          .context
                          .read<HomeTransactionCubit>()
                          .changeSortTransactionBy(
                              sortTransactionBy: SortTransactionBy.amount),
                      title: const Text('Nominal transaksi'),
                    ),
                    RadioListTile<SortTransactionBy>(
                      value: SortTransactionBy.date,
                      groupValue: state.sortTransactionBy,
                      onChanged: (_) => this
                          .context
                          .read<HomeTransactionCubit>()
                          .changeSortTransactionBy(
                              sortTransactionBy: SortTransactionBy.date),
                      title: const Text('Tanggal transaksi'),
                    )
                  ],
                );
              },
            ),
            const Divider(),
            BlocBuilder<HomeTransactionCubit, HomeTransactionState>(
              bloc: this.context.read<HomeTransactionCubit>(),
              buildWhen: (previous, current) =>
                  current.type == StateType.sortTypeChanged,
              builder: (context, state) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    RadioListTile<SortType>(
                      value: SortType.asc,
                      groupValue: state.sortTransactionType,
                      onChanged: (_) => this
                          .context
                          .read<HomeTransactionCubit>()
                          .changeSortTransactionType(sortType: SortType.asc),
                      title: const Text('Menaik'),
                    ),
                    RadioListTile<SortType>(
                      value: SortType.desc,
                      groupValue: state.sortTransactionType,
                      onChanged: (_) => this
                          .context
                          .read<HomeTransactionCubit>()
                          .changeSortTransactionType(sortType: SortType.desc),
                      title: const Text('Menurun'),
                    )
                  ],
                );
              },
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Selesai'),
              ),
            )
          ],
        ),
      );
}

enum FilterCategoryType {
  all,
  income,
  expense,
}
