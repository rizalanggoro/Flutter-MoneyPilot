import 'package:json_annotation/json_annotation.dart';
import 'package:money_pilot/core/enums/allocation_algorithm.dart';
import 'package:money_pilot/domain/models/set_allocation_item.dart';

part 'set_allocation.g.dart';

@JsonSerializable(explicitToJson: true)
class SetAllocation {
  final int? key;
  final String title;
  final int maxAmount;
  final List<SetAllocationItem> setAllocations;
  final AllocationAlgorithm algorithm;

  SetAllocation({
    this.key,
    required this.title,
    required this.maxAmount,
    required this.setAllocations,
    required this.algorithm,
  });

  factory SetAllocation.fromJson(Map<String, dynamic> json) =>
      _$SetAllocationFromJson(json);

  Map<String, dynamic> toJson() => _$SetAllocationToJson(this);

  SetAllocation copyWith({
    int? key,
    String? title,
    int? maxAmount,
    List<SetAllocationItem>? setAllocations,
    AllocationAlgorithm? algorithm,
  }) =>
      SetAllocation(
        key: key ?? this.key,
        title: title ?? this.title,
        maxAmount: maxAmount ?? this.maxAmount,
        setAllocations: setAllocations ?? this.setAllocations,
        algorithm: algorithm ?? this.algorithm,
      );
}
