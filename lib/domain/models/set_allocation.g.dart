// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_allocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetAllocation _$SetAllocationFromJson(Map<String, dynamic> json) =>
    SetAllocation(
      key: json['key'] as int?,
      maxAmount: json['maxAmount'] as int,
      setAllocations: (json['setAllocations'] as List<dynamic>)
          .map((e) => SetAllocationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      algorithm: $enumDecode(_$AllocationAlgorithmEnumMap, json['algorithm']),
    );

Map<String, dynamic> _$SetAllocationToJson(SetAllocation instance) =>
    <String, dynamic>{
      'key': instance.key,
      'maxAmount': instance.maxAmount,
      'setAllocations': instance.setAllocations.map((e) => e.toJson()).toList(),
      'algorithm': _$AllocationAlgorithmEnumMap[instance.algorithm]!,
    };

const _$AllocationAlgorithmEnumMap = {
  AllocationAlgorithm.greedy: 'greedy',
  AllocationAlgorithm.exhaustive: 'exhaustive',
  AllocationAlgorithm.prevalent: 'prevalent',
};
