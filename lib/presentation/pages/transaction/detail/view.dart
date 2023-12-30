import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/params/transaction_detail.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/models/transaction.dart';
import 'package:money_pilot/domain/usecases/delete_transaction.dart';
import 'package:money_pilot/domain/usecases/read_category_by_key.dart';
import 'package:money_pilot/presentation/bloc/transaction/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class PageTransactionDetail extends StatefulWidget {
  final Object? extra;
  const PageTransactionDetail({
    super.key,
    this.extra,
  });

  @override
  State<PageTransactionDetail> createState() => _PageTransactionDetailState();
}

class _PageTransactionDetailState extends State<PageTransactionDetail> {
  Transaction? _transaction;

  @override
  void initState() {
    super.initState();

    if (widget.extra != null && widget.extra is RouteParamTransactionDetail) {
      final params = widget.extra as RouteParamTransactionDetail;
      _transaction = params.transaction;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: BlocListener<TransactionDetailCubit, TransactionDetailState>(
        bloc: context.read<TransactionDetailCubit>(),
        listener: (context, state) {
          if (state.type == StateType.delete) {
            if (state.status.isFailure) {
              Utils.showSnackbar(
                context: context,
                message: state.message,
              );
            }

            if (state.status.isSuccess) {
              if (state.deletedTransaction != null) {
                context
                    .read<CubitTransaction>()
                    .remove(key: state.deletedTransaction!.key ?? -1);
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
            // amount
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                NumberFormat.currency(locale: 'id').format(
                  _transaction?.amount ?? 0,
                ),
                style: Utils.textTheme(context).titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

            // note
            if (_transaction?.note != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Text(_transaction?.note ?? ''),
              ),

            ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.today_rounded,
                ),
              ),
              title: const Text('Tanggal'),
              subtitle: Text(
                _transaction?.dateTime != null
                    ? DateFormat('EEEE, dd MMMM yyyy')
                        .format(_transaction!.dateTime)
                    : '-',
              ),
            ),
            FutureBuilder(
                future: context
                    .read<TransactionDetailCubit>()
                    .readCategoryByKey(key: _transaction?.categoryKey ?? -1),
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
                    title: const Text('Kategori'),
                    subtitle: Text(
                      category?.name ?? 'Tidak ada kategori',
                    ),
                  );
                }),
          ],
        ),
      );

  get _appbar => AppBar(
        title: const Text('Detail transaksi'),
        actions: [
          IconButton(
            onPressed: () => _showDialogConfirmDelete(),
            icon: const Icon(
              Icons.delete_rounded,
            ),
          ),
          const SizedBox(width: 16),
        ],
      );

  _showDialogConfirmDelete() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hapus transaksi'),
          content: const Text(
            'Apakah Anda yakin akan menghapus transaksi ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                this.context.read<TransactionDetailCubit>().delete(
                      transaction: _transaction,
                    );
                context.pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        ),
      );
}
