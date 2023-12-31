import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_pilot/core/enums/allocation_algorithm.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/core/route/params/allocation_create_category.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/domain/models/allocation_category.dart';
import 'package:money_pilot/domain/models/set_allocation.dart';
import 'package:money_pilot/domain/models/set_allocation_item.dart';
import 'package:money_pilot/domain/usecases/create_set_allocation.dart';
import 'package:money_pilot/domain/usecases/generate_allocation_exhaustive.dart';
import 'package:money_pilot/domain/usecases/generate_allocation_fairness.dart';
import 'package:money_pilot/domain/usecases/generate_allocation_greedy.dart';
import 'package:money_pilot/presentation/cubit/set_allocation/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class PageAllocationCreate extends StatefulWidget {
  const PageAllocationCreate({super.key});

  @override
  State<PageAllocationCreate> createState() => _PageAllocationCreateState();
}

class _PageAllocationCreateState extends State<PageAllocationCreate> {
  final TextEditingController _textEditingControllerAmount =
      TextEditingController();
  final _listAlogirthm = [
    _AlgorithmItem(
      title: 'Greedy',
      subtitle: 'Pencarian solusi secara cepat',
      algorithm: AllocationAlgorithm.greedy,
    ),
    _AlgorithmItem(
      title: 'Exhaustive search',
      subtitle: 'Pencarian solusi secara akurat',
      algorithm: AllocationAlgorithm.exhaustive,
    ),
    _AlgorithmItem(
      title: 'Fairness',
      subtitle: 'Pencarian solusi secara adil',
      algorithm: AllocationAlgorithm.fairness,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: BlocListener<AllocationCreateCubit, AllocationCreateState>(
        bloc: context.read<AllocationCreateCubit>(),
        listener: (context, state) {
          if (state.type == StateType.generate) {
            if (state.status.isFailure) {
              Utils.showSnackbar(
                context: context,
                message: state.message,
              );
            }
          }

          if (state.type == StateType.create) {
            if (state.status.isFailure) {
              Utils.showSnackbar(
                context: context,
                message: state.message,
              );
            }

            if (state.status.isSuccess) {
              if (state.createdSetAllocation != null) {
                context.read<CubitSetAllocation>().add(
                      setAllocation: state.createdSetAllocation!,
                    );
              }
              context.pop();
            }
          }
        },
        child: Scaffold(
          appBar: _appbar,
          body: _content,
        ),
      ),
    );
  }

  get _appbar => AppBar(title: const Text('Alokasi baru'));

  get _content => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _contentInputMaxAmount,
            _contentCardAlgorithm,
            _contentHeaderCategory,
            _contentCategory,

            // button generate
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 8,
                right: 16,
                left: 16,
                bottom: 16,
              ),
              child: OutlinedButton(
                onPressed: () => context.read<AllocationCreateCubit>().generate(
                      strMaxAmount: _textEditingControllerAmount.text,
                    ),
                child: const Text('Buat alokasi'),
              ),
            ),

            const Divider(),

            _contentAllocationResult,
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 16,
                bottom: 16,
                right: 16,
                left: 16,
              ),
              child: FilledButton(
                onPressed: () => _showDialogSave(
                  parentContext: context,
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      );

  get _contentInputMaxAmount => Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
        ),
        child: TextField(
          controller: _textEditingControllerAmount,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Masukkan dana maksimal',
          ),
        ),
      );

  get _contentCardAlgorithm => Card(
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const ListTile(
              title: Text('Algoritma'),
              subtitle: Text(
                'Pilih algoritma yang akan digunakan untuk melakukan alokasi dana.',
              ),
            ),
            BlocBuilder<AllocationCreateCubit, AllocationCreateState>(
              bloc: context.read<AllocationCreateCubit>(),
              buildWhen: (previous, current) =>
                  current.type == StateType.allocationAlgorithmChanged,
              builder: (context, state) => ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: _listAlogirthm
                    .map((e) => RadioListTile<AllocationAlgorithm>(
                          title: Text(e.title),
                          subtitle: Text(e.subtitle),
                          value: e.algorithm,
                          groupValue: state.allocationAlgorithm,
                          onChanged: (value) => context
                              .read<AllocationCreateCubit>()
                              .changeAllocationAlgorithm(
                                algorithm: value ?? AllocationAlgorithm.greedy,
                              ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );

  get _contentHeaderCategory => Container(
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kategori',
              style: Utils.textTheme(context).titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Utils.colorScheme(context).onBackground,
                  ),
            ),
            IconButton.filledTonal(
              onPressed: () => context
                  .push(
                Routes.allocationCreateCategory,
                extra: RouteParamAllocationCreateCategory(
                  algorithm: context
                      .read<AllocationCreateCubit>()
                      .state
                      .allocationAlgorithm,
                ),
              )
                  .then((result) {
                if (result != null && result is AllocationCategory) {
                  context.read<AllocationCreateCubit>().addAllocation(
                        allocation: result,
                      );
                }
              }),
              icon: Icon(
                Icons.add_rounded,
                color: Utils.colorScheme(context).onPrimaryContainer,
              ),
            ),
          ],
        ),
      );

  get _contentCategory =>
      BlocBuilder<AllocationCreateCubit, AllocationCreateState>(
        bloc: context.read<AllocationCreateCubit>(),
        buildWhen: (previous, current) =>
            current.type == StateType.allocationsChanged,
        builder: (context, state) {
          final allocations = state.allocations;

          return ReorderableListView.builder(
            footer: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 16,
              ),
              child: Text(
                'Tekan dan tahan untuk memindahkan kategori '
                'sesuai dengan prioritas.',
                textAlign: TextAlign.center,
                style: Utils.textTheme(context).bodySmall,
              ),
            ),
            itemBuilder: (context, index) {
              final allocation = allocations[index];
              return ListTile(
                key: Key('$index'),
                leading:
                    BlocBuilder<AllocationCreateCubit, AllocationCreateState>(
                  bloc: context.read<AllocationCreateCubit>(),
                  buildWhen: (previous, current) =>
                      current.type == StateType.allocationAlgorithmChanged,
                  builder: (context, state) => Badge(
                    smallSize: 8,
                    isLabelVisible: state.allocationAlgorithm.isFairness &&
                        (allocation.isUrgent ?? false),
                    child: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: Utils.textTheme(context).bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Utils.colorScheme(context).onPrimaryContainer,
                            ),
                      ),
                    ),
                  ),
                ),
                title: Text(allocation.category.name),
                subtitle: Text(
                  NumberFormat.currency(
                    locale: 'id',
                  ).format(
                    allocation.amount,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  color: Utils.colorScheme(context).onPrimaryContainer,
                  onPressed: () => _showBottomSheetOptions(
                    parentContext: context,
                    index: index,
                    allocation: allocation,
                  ),
                ),
              );
            },
            itemCount: allocations.length,
            onReorder: (oldIndex, newIndex) =>
                context.read<AllocationCreateCubit>().changeAllocationOrder(
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          );
        },
      );

  get _contentAllocationResult => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16,
            ),
            child: Text(
              'Hasil Pengalokasian Dana',
              style: Utils.textTheme(context).titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Utils.colorScheme(context).onBackground,
                  ),
            ),
          ),
          BlocBuilder<AllocationCreateCubit, AllocationCreateState>(
            bloc: context.read<AllocationCreateCubit>(),
            buildWhen: (previous, current) =>
                current.type == StateType.generate,
            builder: (context, state) {
              final allocationsResult = state.allocationsResult;

              return ListView.builder(
                itemBuilder: (context, index) {
                  final allocation = allocationsResult[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: Utils.textTheme(context).bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Utils.colorScheme(context).onPrimaryContainer,
                            ),
                      ),
                    ),
                    // isThreeLine: true,
                    title: Text(
                      allocation.category.name,
                    ),
                    subtitle: Text(
                      NumberFormat.currency(
                        locale: 'id',
                      ).format(
                        allocation.amount,
                      ),
                    ),
                  );
                },
                itemCount: allocationsResult.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              );
            },
          ),
          ListTile(
            title: const Text('Total'),
            subtitle: BlocBuilder<AllocationCreateCubit, AllocationCreateState>(
              bloc: context.read<AllocationCreateCubit>(),
              buildWhen: (previous, current) =>
                  current.type == StateType.generate,
              builder: (context, state) {
                double totalAmount = 0;
                if (state.allocationsResult.isNotEmpty) {
                  totalAmount = state.allocationsResult.fold(
                    0,
                    (previousValue, element) => previousValue + element.amount,
                  );
                }

                return Text(
                  NumberFormat.currency(locale: 'id').format(totalAmount),
                );
              },
            ),
          ),
        ],
      );

  _showDialogSave({
    required BuildContext parentContext,
  }) {
    final TextEditingController textEditingControllerTitle =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Simpan alokasi'),
        content: TextField(
          controller: textEditingControllerTitle,
          decoration: const InputDecoration(
            filled: true,
            label: Text('Masukkan judul alokasi'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              parentContext.read<AllocationCreateCubit>().createSetAllocation(
                    title: textEditingControllerTitle.text,
                    strMaxAmount: _textEditingControllerAmount.text,
                  );
              context.pop();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  _showBottomSheetOptions({
    required BuildContext parentContext,
    required int index,
    required AllocationCategory allocation,
  }) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(allocation.category.name),
            subtitle: Text(
              NumberFormat.currency(
                locale: 'id',
              ).format(
                allocation.amount,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text('Ubah'),
            onTap: () {
              context
                  .push(
                Routes.allocationCreateCategory,
                extra: RouteParamAllocationCreateCategory(
                  algorithm: parentContext
                      .read<AllocationCreateCubit>()
                      .state
                      .allocationAlgorithm,
                  allocation: allocation,
                ),
              )
                  .then((result) {
                if (result != null && result is AllocationCategory) {
                  parentContext.read<AllocationCreateCubit>().updateAllocation(
                        index: index,
                        allocation: result,
                      );
                }
              });
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_rounded),
            title: const Text('Hapus'),
            onTap: () {
              parentContext.read<AllocationCreateCubit>().removeAllocation(
                    index: index,
                  );
              context.pop();
            },
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: OutlinedButton(
              child: const Text('Batal'),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlgorithmItem {
  final String title;
  final String subtitle;
  final AllocationAlgorithm algorithm;

  _AlgorithmItem({
    required this.title,
    required this.subtitle,
    required this.algorithm,
  });
}
