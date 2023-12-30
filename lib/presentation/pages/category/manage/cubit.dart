part of 'view.dart';

class CategoryManageCubit extends Cubit<CategoryManageState> {
  final UseCaseDeleteCategory _useCaseDeleteCategory;
  final UseCaseFilterCategoryByType _useCaseFilterCategoryByType;

  CategoryManageCubit({
    required UseCaseDeleteCategory useCaseDeleteCategory,
    required UseCaseFilterCategoryByType useCaseFilterCategoryByType,
  })  : _useCaseDeleteCategory = useCaseDeleteCategory,
        _useCaseFilterCategoryByType = useCaseFilterCategoryByType,
        super(CategoryManageState());

  List<Category> filterCategoriesByType({
    required List<Category> categories,
    required CategoryType categoryType,
  }) =>
      _useCaseFilterCategoryByType
          .call(
            ParamsFilterCategoryByType(
              categories: categories,
              type: categoryType,
            ),
          )
          .fold(
            (l) => [],
            (r) => r,
          );

  void delete({
    required Category category,
  }) async {
    if (category.key != null) {
      emit(state.copyWith(
        type: StateType.delete,
        status: StateStatus.loading,
      ));

      final deleteResult = await _useCaseDeleteCategory.call(
        ParamDeleteCategory(
          key: category.key!,
        ),
      );

      deleteResult.fold(
        (l) => emit(state.copyWith(
          type: StateType.delete,
          status: StateStatus.failure,
          message: l.message,
        )),
        (r) => emit(state.copyWith(
          type: StateType.delete,
          status: StateStatus.success,
          deletedCategory: category,
        )),
      );
    }
  }
}
