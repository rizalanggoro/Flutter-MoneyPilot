part of 'view.dart';

class HomeTransactionCubit extends Cubit<HomeTransactionState> {
  final UseCaseSyncReadCategoryByKey _useCaseSyncReadCategoryByKey;
  HomeTransactionCubit({
    required UseCaseSyncReadCategoryByKey useCaseSyncReadCategoryByKey,
  })  : _useCaseSyncReadCategoryByKey = useCaseSyncReadCategoryByKey,
        super(HomeTransactionState());

  void changeFilterCategoryType({
    required CategoryType? categoryType,
  }) =>
      emit(state.copyWith(
        type: StateType.filterCategoryTypeChanged,
        filterCategoryType: categoryType,
      ));

  Category? readCategoryByKey({
    required List<Category> categories,
    int? key,
  }) {
    return _useCaseSyncReadCategoryByKey
        .call(ParamsSyncReadCategoryByKey(
          categories: categories,
          key: key,
        ))
        .fold((l) => null, (r) => r);
  }
}
