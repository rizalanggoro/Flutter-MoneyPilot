import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_pilot/core/enums/allocation_algorithm.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/domain/models/allocation.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/usecases/generate_allocation_exhaustive.dart';
import 'package:money_pilot/domain/usecases/generate_allocation_greedy.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllocationCreateCubit, AllocationCreateState>(
      bloc: context.read<AllocationCreateCubit>(),
      listener: (context, state) {
        if (state.type == StateType.allocation) {
          if (state.status.isFailure) {
            Utils.showSnackbar(
              context: context,
              message: state.message,
            );
          }
        }
      },
      child: Scaffold(
        appBar: _appbar,
        body: _content,
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
                onPressed: () =>
                    context.read<AllocationCreateCubit>().startAllocation(
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
                onPressed: () => {},
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
            labelText: 'Masukkan dana maksimal...',
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
                  ),
            ),
            IconButton.filledTonal(
              onPressed: () => {},
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
            current.type == StateType.allocationOrderChanged,
        builder: (context, state) {
          final allocations = state.allocations;

          return ReorderableListView.builder(
            itemBuilder: (context, index) {
              final allocation = allocations[index];
              return ListTile(
                key: Key('$index'),
                leading: CircleAvatar(
                  child: Text(
                    '${index + 1}',
                    style: Utils.textTheme(context).bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Utils.colorScheme(context).onPrimaryContainer,
                        ),
                  ),
                ),
                title: Text(allocation.category.name),
                subtitle: Text('${allocation.amount}'),
                trailing: Icon(
                  Icons.drag_handle_rounded,
                  color: Utils.colorScheme(context).onPrimaryContainer,
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
                  ),
            ),
          ),
          BlocBuilder<AllocationCreateCubit, AllocationCreateState>(
            bloc: context.read<AllocationCreateCubit>(),
            buildWhen: (previous, current) =>
                current.type == StateType.allocation,
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
                    title: Text(allocation.category.name),
                    subtitle: Text(
                      '${allocation.amount}',
                    ),
                  );
                },
                itemCount: allocationsResult.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              );
            },
          ),
        ],
      );
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
