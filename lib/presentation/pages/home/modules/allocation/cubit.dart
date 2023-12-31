part of 'view.dart';

class HomeAlloactionCubit extends Cubit<HomeAlloactionState> {
  final UseCaseReadCategoryByKey _useCaseReadCategoryByKey;

  HomeAlloactionCubit({
    required UseCaseReadCategoryByKey useCaseReadCategoryByKey,
  })  : _useCaseReadCategoryByKey = useCaseReadCategoryByKey,
        super(HomeAlloactionState());

  void initializeThreshold({
    required List<SetAllocation> setAllocations,
  }) {}

  Future<Category?> getCategoryByKey({
    required int key,
  }) async {
    final readResult = await _useCaseReadCategoryByKey.call(
      ParamReadCategoryByKey(key: key),
    );

    return readResult.fold(
      (l) => null,
      (r) => r,
    );
  }

  Future<double> calculateTotalAmount({
    required List<Transaction> transactions,
    int? categoryKey,
  }) async {
    if (categoryKey == null) {
      return 0;
    }

    final currentDate = DateTime.now();

    double totalAmount = 0;
    for (final transaction in transactions) {
      final isValidDate = transaction.dateTime.month == currentDate.month &&
          transaction.dateTime.year == currentDate.year;

      if (transaction.categoryKey == categoryKey && isValidDate) {
        print(transaction.toJson());
        totalAmount += transaction.amount;
      }
    }

    return totalAmount;
  }
}
