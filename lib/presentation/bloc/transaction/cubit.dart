import 'package:bloc/bloc.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/domain/models/transaction.dart';
import 'package:money_pilot/domain/usecases/read_transactions.dart';

part 'state.dart';

class CubitTransaction extends Cubit<StateTransaction> {
  final UseCaseReadTransactions _useCaseReadTransactions;
  CubitTransaction({
    required UseCaseReadTransactions useCaseReadTransactions,
  })  : _useCaseReadTransactions = useCaseReadTransactions,
        super(StateTransaction());

  void initialize() async {
    emit(state.copyWith(status: StateStatus.loading));
    final readResult = await _useCaseReadTransactions.call(null);
    readResult.fold(
      (l) => emit(state.copyWith(
        status: StateStatus.success,
        transactions: [],
      )),
      (r) => emit(state.copyWith(
        status: StateStatus.success,
        transactions: r,
      )),
    );
  }

  void add({
    required Transaction transaction,
  }) =>
      emit(state.copyWith(
        status: StateStatus.success,
        transactions: List.of(state.transactions)..add(transaction),
      ));

  void remove({
    required Transaction transaction,
  }) {}
}
