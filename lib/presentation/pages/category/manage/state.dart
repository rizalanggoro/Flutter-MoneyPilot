part of 'view.dart';

enum StateType {
  initial,
  delete,
}

class CategoryManageState {
  final StateType type;
  final StateStatus status;
  final String message;
  final Category? deletedCategory;

  CategoryManageState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.message = '',
    this.deletedCategory,
  });

  CategoryManageState copyWith({
    StateType? type,
    StateStatus? status,
    String? message,
    Category? deletedCategory,
  }) =>
      CategoryManageState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message,
        deletedCategory: deletedCategory ?? this.deletedCategory,
      );
}
