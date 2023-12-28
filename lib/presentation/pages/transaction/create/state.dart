part of 'view.dart';

enum StateType {
  initial,
  categoryChanged,
  dateChanged,
  create,
}

class TransactionCreateState {
  final StateType type;
  final StateStatus status;
  final String message;
  final Category? category;
  final DateTime dateTime;

  TransactionCreateState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.message = '',
    this.category,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  TransactionCreateState copyWith({
    StateType? type,
    StateStatus? status,
    String? message,
    Category? category,
    DateTime? dateTime,
  }) =>
      TransactionCreateState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message,
        category: category ?? this.category,
        dateTime: dateTime ?? this.dateTime,
      );
}
