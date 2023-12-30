import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/core/route/params/category_select.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/models/transaction.dart';
import 'package:money_pilot/domain/usecases/create_transaction.dart';
import 'package:money_pilot/presentation/bloc/transaction/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class PageTransactionCreate extends StatefulWidget {
  const PageTransactionCreate({super.key});

  @override
  State<PageTransactionCreate> createState() => _PageTransactionCreateState();
}

class _PageTransactionCreateState extends State<PageTransactionCreate> {
  final TextEditingController _textEditingControllerAmount =
          TextEditingController(),
      _textEditingControllerNote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: BlocListener<TransactionCreateCubit, TransactionCreateState>(
        bloc: context.read<TransactionCreateCubit>(),
        listener: (context, state) {
          if (state.type == StateType.create) {
            if (state.status.isSuccess) {
              context.pop();
            }
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
      ),
    );
  }

  get _appbar => AppBar(title: const Text('Transaksi baru'));

  get _content => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _textEditingControllerAmount,
                decoration: const InputDecoration(
                  filled: true,
                  label: Text('Masukkan nominal'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
              ),
              child: TextField(
                minLines: 3,
                maxLines: null,
                controller: _textEditingControllerNote,
                decoration: const InputDecoration(
                  filled: true,
                  label: Text('Masukkan catatan'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<TransactionCreateCubit, TransactionCreateState>(
              bloc: context.read<TransactionCreateCubit>(),
              buildWhen: (previous, current) =>
                  current.type == StateType.categoryChanged,
              builder: (context, state) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.category_rounded),
                  ),
                  title: const Text('Kategori'),
                  subtitle: Text(
                    state.category?.name ?? 'Tidak ada kategori dipilih',
                  ),
                  onTap: () => context
                      .push(Routes.categorySelect,
                          extra: RouteParamCategorySelect(
                            isExpenseOnly: false,
                            category: state.category,
                          ))
                      .then(
                    (result) {
                      if (result != null && result is Category) {
                        context.read<TransactionCreateCubit>().changeCategory(
                              category: result,
                            );
                      }
                    },
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                );
              },
            ),
            BlocBuilder<TransactionCreateCubit, TransactionCreateState>(
              bloc: context.read<TransactionCreateCubit>(),
              buildWhen: (previous, current) =>
                  current.type == StateType.dateChanged,
              builder: (context, state) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.today_rounded),
                  ),
                  title: const Text('Tanggal'),
                  subtitle: Text(
                    DateFormat('EEEE, dd MMMM yyyy').format(
                      state.dateTime,
                    ),
                  ),
                  onTap: () => _showDatePicker(
                    currentDate: state.dateTime,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.read<TransactionCreateCubit>().create(
                      strAmount: _textEditingControllerAmount.text,
                      note: _textEditingControllerNote.text,
                    ),
                child: const Text('Selesai'),
              ),
            ),
          ],
        ),
      );

  void _showDatePicker({
    required DateTime currentDate,
  }) async {
    final firstDate = DateTime(currentDate.year - 1);
    final lastDate = DateTime(currentDate.year + 1);

    final result = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (result != null && context.mounted) {
      context.read<TransactionCreateCubit>().changeDate(
            newDateTime: result,
          );
    }
  }
}
