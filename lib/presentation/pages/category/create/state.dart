part of 'view.dart';

enum StateType {
  initial,
  categoryTypeChanged,
  create,
  update,
}

class CategoryCreateState {
  final StateType type;
  final StateStatus status;
  final String message;
  final int? key;
  final CategoryType selectedCategoryType;

  CategoryCreateState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.message = '',
    this.key,
    this.selectedCategoryType = CategoryType.income,
  });

  CategoryCreateState copyWith({
    StateType? type,
    StateStatus? status,
    String? message,
    int? key,
    CategoryType? selectedCategoryType,
  }) =>
      CategoryCreateState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message,
        key: key ?? this.key,
        selectedCategoryType: selectedCategoryType ?? this.selectedCategoryType,
      );
}
