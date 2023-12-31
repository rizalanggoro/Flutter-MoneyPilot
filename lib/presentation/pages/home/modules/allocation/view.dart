import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/core/route/params/allocation_detail.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/models/set_allocation.dart';
import 'package:money_pilot/domain/models/transaction.dart';
import 'package:money_pilot/domain/usecases/read_category_by_key.dart';
import 'package:money_pilot/presentation/cubit/category/cubit.dart';
import 'package:money_pilot/presentation/cubit/set_allocation/cubit.dart';
import 'package:money_pilot/presentation/cubit/transaction/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class HomeAllocation extends StatefulWidget {
  const HomeAllocation({super.key});

  @override
  State<HomeAllocation> createState() => _HomeAllocationState();
}

class _HomeAllocationState extends State<HomeAllocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar,
      body: _content,
    );
  }

  get _content => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Rencana anggaran',
                style: Utils.textTheme(context).titleMedium,
              ),
              subtitle: Text(
                DateFormat('MMMM, yyyy').format(DateTime.now()),
              ),
            ),
            const SizedBox(height: 8),
            _threshold,
            const SizedBox(height: 8),
            const Divider(),

            // history
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 8,
              ),
              child: Text(
                'Riyawat alokasi',
                style: Utils.textTheme(context).titleMedium,
              ),
            ),
            _listViewHistoryAllocation,

            // spacer
            const SizedBox(height: 56 + 32 * 2),
          ],
        ),
      );

  get _threshold => Builder(
        builder: (context) {
          final setAllocations =
              context.select<CubitSetAllocation, List<SetAllocation>>(
                  (value) => value.state.setAllocations);
          final stateTransaction =
              context.select<CubitTransaction, StateTransaction>(
                  (value) => value.state);
          final stateCategory = context
              .select<CategoryCubit, CategoryState>((value) => value.state);

          if (stateTransaction.status.isLoading ||
              stateCategory.status.isLoading) {
            return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Text('Memuat data'),
            );
          }

          if (setAllocations.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Text('Tidak ada data rencana anggaran'),
            );
          }

          final setAllocation = setAllocations[0];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemBuilder: (context, index) {
                  final item = setAllocation.setAllocations[index];

                  return FutureBuilder(
                    future: context
                        .read<HomeAlloactionCubit>()
                        .getCategoryByKey(key: item.categoryKey),
                    builder: (context, snapshot) {
                      Category? category;
                      if (snapshot.hasData) {
                        category = snapshot.data;
                      }

                      return FutureBuilder(
                        future: context
                            .read<HomeAlloactionCubit>()
                            .calculateTotalAmount(
                              transactions: stateTransaction.transactions,
                              categoryKey: item.categoryKey,
                            ),
                        builder: (context, snapshot) {
                          double totalAmount = 0;
                          if (snapshot.hasData) {
                            totalAmount = snapshot.data ?? 0;
                          }
                          double percentage = totalAmount / item.amount;

                          return ListTile(
                            leading: CircularProgressIndicator(
                              value: percentage,
                              strokeCap: StrokeCap.round,
                              backgroundColor:
                                  Utils.colorScheme(context).secondaryContainer,
                            ),
                            title: Text(
                              category?.name ?? 'Tidak ada kategori',
                            ),
                            subtitle: Text(
                              '${NumberFormat.currency(locale: 'id').format(totalAmount)}\n'
                              'Dari ${NumberFormat.currency(locale: 'id').format(item.amount)}',
                            ),
                            trailing: Text(
                              '${NumberFormat.decimalPattern().format(
                                percentage * 100,
                              )}%',
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                itemCount: setAllocation.setAllocations.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          );
        },
      );

  get _listViewHistoryAllocation =>
      BlocBuilder<CubitSetAllocation, StateSetAllocation>(
        bloc: context.read<CubitSetAllocation>(),
        builder: (context, state) {
          final setAllocations = state.setAllocations;

          return ListView.builder(
            itemBuilder: (context, index) {
              final setAllocation = setAllocations[index];
              return ListTile(
                title: Text(setAllocation.title),
                subtitle: Text(
                  '${setAllocation.setAllocations.length} kategori',
                ),
                trailing: Text(
                  NumberFormat.currency(
                    locale: 'id',
                  ).format(
                    setAllocation.maxAmount,
                  ),
                ),
                onTap: () => context.push(
                  Routes.allocationDetail,
                  extra: RouteParamAllocationDetail(
                    setAllocation: setAllocation,
                  ),
                ),
              );
            },
            shrinkWrap: true,
            itemCount: setAllocations.length,
            physics: const NeverScrollableScrollPhysics(),
          );
        },
      );

  get _appbar => AppBar(title: const Text('Alokasi'));
}
