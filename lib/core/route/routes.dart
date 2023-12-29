part of 'config.dart';

sealed class Routes {
  static const home = '/';

  // category
  static const categoryManage = '/category-manage';
  static const categoryCreate = '/category-create';
  static const categorySelect = '/category-select';

  // transaction
  static const transactionCreate = '/transaction-create';

  // allocation
  static const allocationCreate = '/allocation-create';
  static const allocationCreateCategory = '/allocation-create-category';
}
