part of 'view.dart';

class HomeTransactionCubit extends Cubit<HomeTransactionState> {
  final UseCaseReadCategoryByKey _useCaseSyncReadCategoryByKey;
  final UseCaseFilterTransactionByCategoryType
      _useCaseFilterTransactionByCategoryType;
  final UseCaseSortTransaction _useCaseSortTransaction;

  HomeTransactionCubit({
    required UseCaseReadCategoryByKey useCaseSyncReadCategoryByKey,
    required UseCaseFilterTransactionByCategoryType
        useCaseFilterTransactionByCategoryType,
    required UseCaseSortTransaction useCaseSortTransaction,
  })  : _useCaseSyncReadCategoryByKey = useCaseSyncReadCategoryByKey,
        _useCaseFilterTransactionByCategoryType =
            useCaseFilterTransactionByCategoryType,
        _useCaseSortTransaction = useCaseSortTransaction,
        super(HomeTransactionState());

  void changeFilterCategoryType({
    required FilterCategoryType categoryType,
  }) =>
      emit(state.copyWith(
        type: StateType.filterCategoryTypeChanged,
        filterCategoryType: categoryType,
      ));

  Future<Category?> readCategoryByKey({
    required int key,
  }) async {
    final readResult = await _useCaseSyncReadCategoryByKey.call(
      ParamReadCategoryByKey(
        key: key,
      ),
    );
    return readResult.fold(
      (l) => null,
      (r) => r,
    );
  }

  Future<List<Transaction>> filterTransactionByCategoryType({
    required List<Category> categories,
    required List<Transaction> transactions,
  }) async {
    List<Transaction> filteredTransaction = [];

    if (state.filterCategoryType == FilterCategoryType.all) {
      filteredTransaction = transactions;
    } else {
      final categoryType = state.filterCategoryType == FilterCategoryType.income
          ? CategoryType.income
          : CategoryType.expense;
      final filterResult = await _useCaseFilterTransactionByCategoryType.call(
        ParamFilterTransactionByCategoryType(
          categories: categories,
          transactions: transactions,
          categoryType: categoryType,
        ),
      );

      filteredTransaction = filterResult.fold(
        (l) => <Transaction>[],
        (r) => r,
      );
    }

    // sort
    final sortResult = await _useCaseSortTransaction.call(ParamSortTransaction(
      transactions: filteredTransaction,
      sortTransactionBy: state.sortTransactionBy,
      sortType: state.sortTransactionType,
    ));

    return sortResult.fold(
      (l) => [],
      (r) => r,
    );
  }

  void changeSortTransactionBy({
    required SortTransactionBy sortTransactionBy,
  }) =>
      emit(state.copyWith(
        type: StateType.sortByChanged,
        sortTransactionBy: sortTransactionBy,
      ));

  void changeSortTransactionType({
    required SortType sortType,
  }) =>
      emit(state.copyWith(
        type: StateType.sortTypeChanged,
        sortTransactionType: sortType,
      ));
}
