part of 'cubit.dart';

class CategoryState {
  final StateStatus status;
  final List<Category> categories;

  const CategoryState({
    this.status = StateStatus.initial,
    this.categories = const [],
  });

  CategoryState copyWith({
    StateStatus? status,
    List<Category>? categories,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
    );
  }
}
