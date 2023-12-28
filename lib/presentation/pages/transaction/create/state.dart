part of 'view.dart';

enum StateType {
  initial,
  categoryChanged,
  dateChanged,
}

class TransactionCreateState {
  final StateType type;
  final StateStatus status;
  final Category? category;
  final DateTime dateTime;

  TransactionCreateState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.category,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  TransactionCreateState copyWith({
    StateType? type,
    StateStatus? status,
    Category? category,
    DateTime? dateTime,
  }) =>
      TransactionCreateState(
        type: type ?? this.type,
        status: status ?? this.status,
        category: category ?? this.category,
        dateTime: dateTime ?? this.dateTime,
      );
}
