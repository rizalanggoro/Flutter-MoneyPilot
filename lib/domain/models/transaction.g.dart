// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      key: json['key'] as int?,
      amount: json['amount'] as int,
      note: json['note'] as String?,
      categoryKey: json['categoryKey'] as int?,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'key': instance.key,
      'amount': instance.amount,
      'note': instance.note,
      'categoryKey': instance.categoryKey,
      'dateTime': instance.dateTime.toIso8601String(),
    };
