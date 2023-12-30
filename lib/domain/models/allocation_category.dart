import 'package:money_pilot/domain/models/category.dart';

class AllocationCategory {
  final int amount;
  final Category category;
  final double? density;
  final bool? isUrgent;

  const AllocationCategory({
    required this.amount,
    required this.category,
    this.density,
    this.isUrgent,
  });

  AllocationCategory copyWith({
    int? amount,
    Category? category,
    double? density,
    bool? isUrgent,
  }) =>
      AllocationCategory(
        amount: amount ?? this.amount,
        category: category ?? this.category,
        density: density ?? this.density,
        isUrgent: isUrgent ?? this.isUrgent,
      );
}
