import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  final int? key;
  final int amount;
  final String? note;
  final int? categoryKey;
  final DateTime dateTime;

  Transaction({
    this.key,
    required this.amount,
    this.note,
    this.categoryKey,
    required this.dateTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  Transaction copyWith({
    int? key,
    int? amount,
    String? note,
    int? categoryKey,
    DateTime? dateTime,
  }) =>
      Transaction(
        key: key ?? this.key,
        amount: amount ?? this.amount,
        note: note ?? this.note,
        categoryKey: categoryKey ?? this.categoryKey,
        dateTime: dateTime ?? this.dateTime,
      );
}
