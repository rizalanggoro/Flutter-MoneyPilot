part of 'view.dart';

class CategoryCreateCubit extends Cubit<CategoryCreateState> {
  final CategoryCubit _categoryBloc;
  final UseCaseAsyncCreateCategory _useCaseCreateCategory;
  final UseCaseAsyncUpdateCategory _useCaseAsyncUpdateCategory;

  CategoryCreateCubit({
    required CategoryCubit categoryBloc,
    required UseCaseAsyncCreateCategory useCaseCreateCategory,
    required UseCaseAsyncUpdateCategory useCaseAsyncUpdateCategory,
  })  : _categoryBloc = categoryBloc,
        _useCaseCreateCategory = useCaseCreateCategory,
        _useCaseAsyncUpdateCategory = useCaseAsyncUpdateCategory,
        super(CategoryCreateState());

  void initialize({
    required Category category,
  }) =>
      emit(state.copyWith(
        key: category.key,
        selectedCategoryType: category.type,
      ));

  void changeSelectedCategoryType({
    required CategoryType newType,
  }) =>
      emit(state.copyWith(
        type: StateType.categoryTypeChanged,
        selectedCategoryType: newType,
      ));

  void done({
    required String name,
    required bool isUpdate,
  }) async {
    final category = Category(
      key: state.key,
      name: name,
      type: state.selectedCategoryType,
    );

    if (isUpdate) {
      emit(state.copyWith(
        type: StateType.update,
        status: StateStatus.loading,
      ));

      final updateResult = await _useCaseAsyncUpdateCategory.call(
        category,
      );

      updateResult.fold(
        (l) => emit(state.copyWith(
          type: StateType.update,
          status: StateStatus.failure,
          message: l.message,
        )),
        (r) {
          _categoryBloc.update(
            newCategory: category,
          );
          emit(state.copyWith(
            type: StateType.update,
            status: StateStatus.success,
          ));
        },
      );
    } else {
      emit(state.copyWith(
        type: StateType.create,
        status: StateStatus.loading,
      ));

      final createResult = await _useCaseCreateCategory.call(
        category,
      );

      createResult.fold(
        (l) => emit(state.copyWith(
          type: StateType.create,
          status: StateStatus.failure,
          message: l.message,
        )),
        (r) {
          _categoryBloc.add(
            category: category.copyWith(
              key: r,
            ),
          );

          emit(state.copyWith(
            type: StateType.create,
            status: StateStatus.success,
          ));
        },
      );
    }
  }
}
