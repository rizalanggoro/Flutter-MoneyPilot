import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/core/route/params/transaction_detail.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/models/transaction.dart';
import 'package:money_pilot/domain/usecases/filter_transaction_by_category_type.dart';
import 'package:money_pilot/domain/usecases/read_category_by_key.dart';
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
              final transactionState = context.watch<CubitTransaction>().state;
              final _ =
                  context.select<HomeTransactionCubit, FilterCategoryType>(
                      (value) => value.state.filterCategoryType);

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
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];

                      return FutureBuilder(
                        future: context
                            .read<HomeTransactionCubit>()
                            .readCategoryByKey(
                                key: transaction.categoryKey ?? -1),
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
                              NumberFormat.currency(locale: 'id')
                                  .format(transaction.amount),
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
                    },
                    itemCount: transactions.length,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

enum FilterCategoryType {
  all,
  income,
  expense,
}
