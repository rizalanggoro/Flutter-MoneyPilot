import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/usecases/sync/read_category_by_key.dart';
import 'package:money_pilot/presentation/bloc/category/cubit.dart';
import 'package:money_pilot/presentation/bloc/transaction/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class HomeTransaction extends StatelessWidget {
  const HomeTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                return SegmentedButton<CategoryType?>(
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
                      value: null,
                      label: Text('Semua'),
                    ),
                    ButtonSegment(
                      value: CategoryType.income,
                      label: Text('Pemasukan'),
                    ),
                    ButtonSegment(
                      value: CategoryType.expense,
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
              final transactionState = context.watch<CubitTransaction>().state;

              if (transactionState.status.isLoading ||
                  categoryState.status.isLoading) {
                return const Center(
                  child: Text('Memuat data transaksi'),
                );
              }

              final categories = categoryState.categories;
              final transactions = transactionState.transactions;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final category =
                      context.read<HomeTransactionCubit>().readCategoryByKey(
                            categories: categories,
                            key: transaction.categoryKey,
                          );

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
                      DateFormat(
                        'EEE, dd MMM yy',
                      ).format(
                        transaction.dateTime,
                      ),
                    ),
                    trailing: Text(
                      NumberFormat.currency(locale: 'id')
                          .format(transaction.amount),
                    ),
                    onTap: () => {},
                  );
                },
                itemCount: transactions.length,
              );
            },
          ),
        ],
      ),
    );
  }
}
