import 'package:money_pilot/domain/models/category.dart';

class RouteParamCategorySelect {
  final Category? category;
  final bool? isExpenseOnly;
  RouteParamCategorySelect({
    this.category,
    this.isExpenseOnly,
  });
}
