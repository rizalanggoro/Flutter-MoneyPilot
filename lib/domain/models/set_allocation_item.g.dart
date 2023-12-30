// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_allocation_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetAllocationItem _$SetAllocationItemFromJson(Map<String, dynamic> json) =>
    SetAllocationItem(
      amount: json['amount'] as int,
      categoryKey: json['categoryKey'] as int,
      density: (json['density'] as num?)?.toDouble(),
      isUrgent: json['isUrgent'] as bool?,
    );

Map<String, dynamic> _$SetAllocationItemToJson(SetAllocationItem instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'categoryKey': instance.categoryKey,
      'density': instance.density,
      'isUrgent': instance.isUrgent,
    };
