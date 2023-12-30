import 'package:money_pilot/core/application/service_locator.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/usecases/async/create_category.dart';

class DebugSeederCategories {
  final _incomes = const <Category>[
    Category(name: 'Uang saku', type: CategoryType.income),
    Category(name: 'Hadiah', type: CategoryType.income),
    Category(name: 'Penjualan', type: CategoryType.income),
    Category(name: 'Lainnya', type: CategoryType.income),
  ];

  final _expenses = const <Category>[
    Category(name: 'Makan dan minum', type: CategoryType.expense),
    Category(name: 'Transportasi', type: CategoryType.expense),
    Category(name: 'Hiburan', type: CategoryType.expense),
    Category(name: 'Investasi', type: CategoryType.expense),
    Category(name: 'Pendidikan', type: CategoryType.expense),
    Category(name: 'Listrik', type: CategoryType.expense),
    Category(name: 'Kesehatan', type: CategoryType.expense),
  ];

  final UseCaseAsyncCreateCategory _useCaseAsyncCreateCategory =
      serviceLocator();
  void call() async {
    for (final income in _incomes) {
      await _useCaseAsyncCreateCategory.call(income);
    }

    for (final expense in _expenses) {
      await _useCaseAsyncCreateCategory.call(expense);
    }
  }
}
