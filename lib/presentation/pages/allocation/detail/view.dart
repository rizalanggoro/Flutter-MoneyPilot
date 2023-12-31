import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/params/allocation_detail.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/models/set_allocation.dart';
import 'package:money_pilot/domain/usecases/delete_set_allocation.dart';
import 'package:money_pilot/domain/usecases/read_category_by_key.dart';
import 'package:money_pilot/presentation/cubit/set_allocation/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class PageAllocationDetail extends StatefulWidget {
  final Object? extra;
  const PageAllocationDetail({
    super.key,
    this.extra,
  });

  @override
  State<PageAllocationDetail> createState() => _PageAllocationDetailState();
}

class _PageAllocationDetailState extends State<PageAllocationDetail> {
  late SetAllocation _setAllocation;

  @override
  void initState() {
    super.initState();

    if (widget.extra != null && widget.extra is RouteParamAllocationDetail) {
      final params = widget.extra as RouteParamAllocationDetail;
      _setAllocation = params.setAllocation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: BlocListener<AllocationDetailCubit, AllocationDetailState>(
        bloc: context.read<AllocationDetailCubit>(),
        listener: (context, state) {
          if (state.type == StateType.delete) {
            if (state.status.isFailure) {
              Utils.showSnackbar(
                context: context,
                message: state.message,
              );
            }

            if (state.status.isSuccess) {
              if (state.deletedSetAllocation != null) {
                context
                    .read<CubitSetAllocation>()
                    .remove(key: state.deletedSetAllocation?.key ?? -1);
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

  get _content => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.payments_rounded,
                ),
              ),
              title: const Text('Dana maksimal'),
              subtitle: Text(
                NumberFormat.currency(locale: 'id').format(
                  _setAllocation.maxAmount,
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.route_rounded,
                ),
              ),
              title: const Text('Algoritma'),
              subtitle: Text(_setAllocation.algorithm.name),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 12,
              ),
              child: Text(
                'Alokasi',
                style: Utils.textTheme(context)
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                final item = _setAllocation.setAllocations[index];
                return FutureBuilder(
                  future: context
                      .read<AllocationDetailCubit>()
                      .readCategoryByKey(key: item.categoryKey),
                  builder: (context, snapshot) {
                    Category? category;
                    if (snapshot.hasData) {
                      category = snapshot.data;
                    }

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(category?.name ?? 'Tidak ada kategori'),
                      subtitle: Text(
                        NumberFormat.currency(locale: 'id').format(item.amount),
                      ),
                    );
                  },
                );
              },
              itemCount: _setAllocation.setAllocations.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      );

  get _appbar => AppBar(
        title: const Text('Detail alokasi'),
        actions: [
          IconButton(
            onPressed: () => _showDialogConfirmDelete(),
            icon: const Icon(Icons.delete_rounded),
          ),
          const SizedBox(width: 16),
        ],
      );

  _showDialogConfirmDelete() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hapus alokasi'),
          content: const Text(
            'Apakah Anda yakin akan menghapus alokasi ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                this
                    .context
                    .read<AllocationDetailCubit>()
                    .delete(setAllocation: _setAllocation);
                context.pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        ),
      );
}
