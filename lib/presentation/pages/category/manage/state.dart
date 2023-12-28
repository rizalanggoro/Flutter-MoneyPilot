part of 'view.dart';

enum StateType {
  initial,
  delete,
}

class CategoryManageState {
  final StateType type;
  final StateStatus status;
  final String message;

  CategoryManageState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.message = '',
  });

  CategoryManageState copyWith({
    StateType? type,
    StateStatus? status,
    String? message,
  }) =>
      CategoryManageState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message,
      );
}
