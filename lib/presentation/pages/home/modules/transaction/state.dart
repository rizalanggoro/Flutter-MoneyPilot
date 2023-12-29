part of 'view.dart';

enum StateType {
  initial,
  filterCategoryTypeChanged,
}

class HomeTransactionState {
  final StateType type;
  final CategoryType? filterCategoryType;
  HomeTransactionState({
    this.type = StateType.initial,
    this.filterCategoryType,
  });

  HomeTransactionState copyWith({
    StateType? type,
    CategoryType? filterCategoryType,
  }) =>
      HomeTransactionState(
        type: type ?? this.type,
        filterCategoryType: filterCategoryType,
      );
}
