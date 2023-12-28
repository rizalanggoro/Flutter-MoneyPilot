part of 'view.dart';

enum StateType { initial, categoryTypeChanged, create }

class CategoryCreateState {
  final StateType type;
  final StateStatus status;
  final String message;
  final CategoryType selectedCategoryType;

  CategoryCreateState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.message = '',
    this.selectedCategoryType = CategoryType.income,
  });

  CategoryCreateState copyWith({
    StateType? type,
    StateStatus? status,
    String? message,
    CategoryType? selectedCategoryType,
  }) =>
      CategoryCreateState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message,
        selectedCategoryType: selectedCategoryType ?? this.selectedCategoryType,
      );
}
