part of 'category_bloc.dart';

sealed class CategoryEvent {}

final class CategoryInitialEvent extends CategoryEvent {}

final class CategoryAddEvent extends CategoryEvent {
  final Category category;
  CategoryAddEvent({
    required this.category,
  });
}

final class CategoryRemoveEvent extends CategoryEvent {
  final Category category;
  CategoryRemoveEvent({
    required this.category,
  });
}
