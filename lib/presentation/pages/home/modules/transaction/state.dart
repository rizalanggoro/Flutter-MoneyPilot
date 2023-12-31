part of 'view.dart';

enum StateType {
  initial,
  filterCategoryTypeChanged,
}

class HomeTransactionState {
  final StateType type;
  final StateStatus status;
  final FilterCategoryType filterCategoryType;
  HomeTransactionState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.filterCategoryType = FilterCategoryType.all,
  });

  HomeTransactionState copyWith({
    StateType? type,
    StateStatus? status,
    FilterCategoryType? filterCategoryType,
  }) =>
      HomeTransactionState(
        type: type ?? this.type,
        status: status ?? this.status,
        filterCategoryType: filterCategoryType ?? this.filterCategoryType,
      );
}
