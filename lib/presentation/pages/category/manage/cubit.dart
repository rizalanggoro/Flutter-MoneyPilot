part of 'view.dart';

class CategoryManageCubit extends Cubit<CategoryManageState> {
  final CategoryCubit _categoryBloc;
  final UseCaseDeleteCategory _useCaseDeleteCategory;
  final UseCaseFilterCategoryByType _useCaseFilterCategoryByType;

  CategoryManageCubit({
    required CategoryCubit categoryBloc,
    required UseCaseDeleteCategory useCaseDeleteCategory,
    required UseCaseFilterCategoryByType useCaseFilterCategoryByType,
  })  : _categoryBloc = categoryBloc,
        _useCaseDeleteCategory = useCaseDeleteCategory,
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
    emit(state.copyWith(
      type: StateType.delete,
      status: StateStatus.loading,
    ));

    final deleteResult = await _useCaseDeleteCategory.call(category);

    deleteResult.fold(
      (l) => emit(state.copyWith(
        type: StateType.delete,
        status: StateStatus.failure,
        message: l.message,
      )),
      (r) {
        _categoryBloc.remove(
          category: category,
        );
        emit(state.copyWith(
          type: StateType.delete,
          status: StateStatus.success,
        ));
      },
    );
  }
}
