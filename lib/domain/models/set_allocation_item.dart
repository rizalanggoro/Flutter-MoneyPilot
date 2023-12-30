import 'package:json_annotation/json_annotation.dart';

part 'set_allocation_item.g.dart';

@JsonSerializable()
class SetAllocationItem {
  final int amount;
  final int categoryKey;
  final double? density;
  final bool? isUrgent;

  SetAllocationItem({
    required this.amount,
    required this.categoryKey,
    this.density,
    this.isUrgent,
  });

  factory SetAllocationItem.fromJson(Map<String, dynamic> json) =>
      _$SetAllocationItemFromJson(json);

  Map<String, dynamic> toJson() => _$SetAllocationItemToJson(this);
}
