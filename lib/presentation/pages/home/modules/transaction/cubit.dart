part of 'view.dart';

class HomeTransactionCubit extends Cubit<HomeTransactionState> {
  final UseCaseReadCategoryByKey _useCaseSyncReadCategoryByKey;
  HomeTransactionCubit({
    required UseCaseReadCategoryByKey useCaseSyncReadCategoryByKey,
  })  : _useCaseSyncReadCategoryByKey = useCaseSyncReadCategoryByKey,
        super(HomeTransactionState());

  void changeFilterCategoryType({
    required CategoryType? categoryType,
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
}
