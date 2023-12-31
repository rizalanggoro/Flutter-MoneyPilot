part of 'view.dart';

class HomeTransactionCubit extends Cubit<HomeTransactionState> {
  final UseCaseReadCategoryByKey _useCaseSyncReadCategoryByKey;
  final UseCaseFilterTransactionByCategoryType
      _useCaseFilterTransactionByCategoryType;
  HomeTransactionCubit({
    required UseCaseReadCategoryByKey useCaseSyncReadCategoryByKey,
    required UseCaseFilterTransactionByCategoryType
        useCaseFilterTransactionByCategoryType,
  })  : _useCaseSyncReadCategoryByKey = useCaseSyncReadCategoryByKey,
        _useCaseFilterTransactionByCategoryType =
            useCaseFilterTransactionByCategoryType,
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
    if (state.filterCategoryType == FilterCategoryType.all) {
      return transactions;
    }

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

    return filterResult.fold(
      (l) => [],
      (r) => r,
    );
  }
}
