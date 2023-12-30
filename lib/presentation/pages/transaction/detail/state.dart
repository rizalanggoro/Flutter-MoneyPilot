part of 'view.dart';

enum StateType {
  initial,
  delete,
}

class TransactionDetailState {
  final StateType type;
  final StateStatus status;
  final String message;
  final Transaction? deletedTransaction;

  TransactionDetailState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.message = '',
    this.deletedTransaction,
  });

  TransactionDetailState copyWith({
    StateType? type,
    StateStatus? status,
    String? message,
    Transaction? deletedTransaction,
  }) =>
      TransactionDetailState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message,
        deletedTransaction: deletedTransaction ?? this.deletedTransaction,
      );
}
