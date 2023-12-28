part of 'view.dart';

class CategorySelectCubit extends Cubit<void> {
  final UseCaseFilterCategoryByType _useCaseFilterCategoryByType;

  CategorySelectCubit({
    required UseCaseFilterCategoryByType useCaseFilterCategoryByType,
  })  : _useCaseFilterCategoryByType = useCaseFilterCategoryByType,
        super(null);

  List<Category> filterByType({
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
}
