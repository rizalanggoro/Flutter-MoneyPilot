part of 'transaction_bloc.dart';

class TransactionState {
  final StateStatus status;
  final List<Transaction> transactions;
  TransactionState({
    this.status = StateStatus.initial,
    this.transactions = const [],
  });

  TransactionState copyWith({
    StateStatus? status,
    List<Transaction>? transactions,
  }) =>
      TransactionState(
        status: status ?? this.status,
        transactions: transactions ?? this.transactions,
      );
}
