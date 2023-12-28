import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

enum CategoryType {
  @JsonValue(0)
  income,
  @JsonValue(1)
  expense,
}

@JsonSerializable()
class Category {
  final int? key;
  final String name;
  final CategoryType type;

  const Category({
    this.key,
    required this.name,
    required this.type,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith({
    int? key,
    String? name,
    CategoryType? type,
  }) =>
      Category(
        key: key ?? this.key,
        name: name ?? this.name,
        type: type ?? this.type,
      );
}
