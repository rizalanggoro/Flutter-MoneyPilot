import 'package:json_annotation/json_annotation.dart';
import 'package:money_pilot/domain/models/category.dart';

part 'allocation.g.dart';

@JsonSerializable()
class Allocation {
  final int? key;
  final int amount;
  final Category category;
  final double? density;
  final bool? isUrgent;

  const Allocation({
    this.key,
    required this.amount,
    required this.category,
    this.density,
    this.isUrgent,
  });

  factory Allocation.fromJson(Map<String, dynamic> json) =>
      _$AllocationFromJson(json);

  Map<String, dynamic> toJson() => _$AllocationToJson(this);

  Allocation copyWith({
    int? key,
    int? amount,
    Category? category,
    double? density,
    bool? isUrgent,
  }) =>
      Allocation(
        key: key ?? this.key,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        density: density ?? this.density,
        isUrgent: isUrgent ?? this.isUrgent,
      );
}
