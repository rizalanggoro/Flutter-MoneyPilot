part of 'view.dart';

class HomeTransactionCubit extends Cubit<void> {
  final UseCaseSyncReadCategoryByKey _useCaseSyncReadCategoryByKey;
  HomeTransactionCubit({
    required UseCaseSyncReadCategoryByKey useCaseSyncReadCategoryByKey,
  })  : _useCaseSyncReadCategoryByKey = useCaseSyncReadCategoryByKey,
        super(null);

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
