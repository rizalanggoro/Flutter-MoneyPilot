part of 'view.dart';

class CategoryCreateCubit extends Cubit<CategoryCreateState> {
  final CategoryBloc _categoryBloc;
  final UseCaseCreateCategory _useCaseCreateCategory;

  CategoryCreateCubit({
    required CategoryBloc categoryBloc,
    required UseCaseCreateCategory useCaseCreateCategory,
  })  : _categoryBloc = categoryBloc,
        _useCaseCreateCategory = useCaseCreateCategory,
        super(CategoryCreateState());

  void create({
    required String name,
  }) async {
    emit(state.copyWith(
      type: StateType.create,
      status: StateStatus.loading,
    ));

    final category = Category(
      name: name,
      type: state.selectedCategoryType,
    );

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
          CategoryAddEvent(
            category: category.copyWith(
              key: r,
            ),
          ),
        );

        emit(state.copyWith(
          type: StateType.create,
          status: StateStatus.success,
        ));
      },
    );
  }

  void changeSelectedCategoryType({
    required CategoryType newType,
  }) =>
      emit(state.copyWith(
        type: StateType.categoryTypeChanged,
        selectedCategoryType: newType,
      ));
}
