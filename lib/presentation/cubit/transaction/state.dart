part of 'cubit.dart';

class StateTransaction {
  final StateStatus status;
  final List<Transaction> transactions;
  StateTransaction({
    this.status = StateStatus.initial,
    this.transactions = const [],
  });

  StateTransaction copyWith({
    StateStatus? status,
    List<Transaction>? transactions,
  }) =>
      StateTransaction(
        status: status ?? this.status,
        transactions: transactions ?? this.transactions,
      );
}
