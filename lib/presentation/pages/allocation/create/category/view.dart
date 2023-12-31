import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/enums/allocation_algorithm.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/core/route/params/allocation_create_category.dart';
import 'package:money_pilot/core/route/params/category_select.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/domain/models/allocation_category.dart';
import 'package:money_pilot/domain/models/category.dart';

part 'cubit.dart';
part 'state.dart';

class PageAllocationCreateCategory extends StatefulWidget {
  final Object? extra;
  const PageAllocationCreateCategory({
    super.key,
    this.extra,
  });

  @override
  State<PageAllocationCreateCategory> createState() =>
      _PageAllocationCreateCategoryState();
}

class _PageAllocationCreateCategoryState
    extends State<PageAllocationCreateCategory> {
  final TextEditingController _textEditingControllerAmount =
      TextEditingController();

  AllocationAlgorithm _algorithm = AllocationAlgorithm.greedy;
  AllocationCategory? _allocation;

  @override
  void initState() {
    super.initState();

    if (widget.extra != null &&
        widget.extra is RouteParamAllocationCreateCategory) {
      final param = widget.extra as RouteParamAllocationCreateCategory;
      _algorithm = param.algorithm;
      _allocation = param.allocation;

      if (_allocation != null) {
        _textEditingControllerAmount.text =
            _allocation?.amount.toString() ?? '0';

        context.read<AllocationCreateCategoryCubit>().initialize(
              allocation: _allocation!,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: BlocListener<AllocationCreateCategoryCubit,
          AllocationCreateCategoryState>(
        bloc: context.read<AllocationCreateCategoryCubit>(),
        listener: (context, state) {
          if (state.type == StateType.create) {
            if (state.status.isFailure) {
              Utils.showSnackbar(
                context: context,
                message: state.message,
              );
            }

            if (state.status.isSuccess) {
              var amount = 0;
              final strAmount = _textEditingControllerAmount.text;
              if (strAmount.isNotEmpty) {
                amount = int.parse(strAmount);
              }

              context.pop(AllocationCategory(
                amount: amount,
                category: state.category!,
                isUrgent: state.urgency ?? false,
              ));
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

  get _appbar => AppBar(title: const Text('Tambah kategori'));

  get _content => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16,
            ),
            child: TextField(
              controller: _textEditingControllerAmount,
              decoration: const InputDecoration(
                filled: true,
                label: Text('Masukkan alokasi'),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          BlocBuilder<AllocationCreateCategoryCubit,
              AllocationCreateCategoryState>(
            bloc: context.read<AllocationCreateCategoryCubit>(),
            buildWhen: (previous, current) =>
                current.type == StateType.categoryChanged,
            builder: (context, state) => ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.category_rounded,
                ),
              ),
              title: const Text('Kategori'),
              subtitle: Text(
                state.category?.name ?? 'Kategori belum dipilih',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context
                  .push(
                Routes.categorySelect,
                extra: RouteParamCategorySelect(
                  isExpenseOnly: true,
                  category: state.category,
                ),
              )
                  .then((result) {
                if (result is Category) {
                  context.read<AllocationCreateCategoryCubit>().changeCategory(
                        category: result,
                      );
                }
              }),
            ),
          ),
          // if (_algorithm.isFairness)
          //   BlocBuilder<AllocationCreateCategoryCubit,
          //       AllocationCreateCategoryState>(
          //     bloc: context.read<AllocationCreateCategoryCubit>(),
          //     buildWhen: (previous, current) =>
          //         current.type == StateType.urgencyChanged,
          //     builder: (context, state) {
          //       return CheckboxListTile(
          //         secondary: const CircleAvatar(
          //           child: Icon(
          //             Icons.priority_high_rounded,
          //           ),
          //         ),
          //         title: const Text('Urgensi'),
          //         subtitle: const Text('Penting'),
          //         value: state.urgency ?? false,
          //         onChanged: (value) => context
          //             .read<AllocationCreateCategoryCubit>()
          //             .changeUrgency(
          //               urgency: value ?? false,
          //             ),
          //       );
          //     },
          //   ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () =>
                  context.read<AllocationCreateCategoryCubit>().done(),
              child: const Text('Selesai'),
            ),
          ),
        ],
      );
}
