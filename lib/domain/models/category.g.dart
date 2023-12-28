// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      key: json['key'] as int?,
      name: json['name'] as String,
      type: $enumDecode(_$CategoryTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'type': _$CategoryTypeEnumMap[instance.type]!,
    };

const _$CategoryTypeEnumMap = {
  CategoryType.income: 0,
  CategoryType.expense: 1,
};
