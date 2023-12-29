// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Allocation _$AllocationFromJson(Map<String, dynamic> json) => Allocation(
      key: json['key'] as int?,
      amount: json['amount'] as int,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      density: (json['density'] as num?)?.toDouble(),
      isUrgent: json['isUrgent'] as bool?,
    );

Map<String, dynamic> _$AllocationToJson(Allocation instance) =>
    <String, dynamic>{
      'key': instance.key,
      'amount': instance.amount,
      'category': instance.category,
      'density': instance.density,
      'isUrgent': instance.isUrgent,
    };
