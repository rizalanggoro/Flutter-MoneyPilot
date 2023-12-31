part of 'view.dart';

enum StateType {
  initial,
  filterCategoryTypeChanged,
  sortByChanged,
  sortTypeChanged,
}

class HomeTransactionState {
  final StateType type;
  final StateStatus status;
  final FilterCategoryType filterCategoryType;
  final SortTransactionBy sortTransactionBy;
  final SortType sortTransactionType;
  HomeTransactionState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.filterCategoryType = FilterCategoryType.all,
    this.sortTransactionBy = SortTransactionBy.date,
    this.sortTransactionType = SortType.desc,
  });

  HomeTransactionState copyWith({
    StateType? type,
    StateStatus? status,
    FilterCategoryType? filterCategoryType,
    SortTransactionBy? sortTransactionBy,
    SortType? sortTransactionType,
  }) =>
      HomeTransactionState(
        type: type ?? this.type,
        status: status ?? this.status,
        filterCategoryType: filterCategoryType ?? this.filterCategoryType,
        sortTransactionBy: sortTransactionBy ?? this.sortTransactionBy,
        sortTransactionType: sortTransactionType ?? this.sortTransactionType,
      );
}
