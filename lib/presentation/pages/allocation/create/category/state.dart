part of 'view.dart';

enum StateType {
  initial,
  categoryChanged,
  urgencyChanged,
  create,
}

class AllocationCreateCategoryState {
  final StateType type;
  final StateStatus status;
  final String message;
  final Category? category;
  final bool? urgency;
  AllocationCreateCategoryState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.message = '',
    this.category,
    this.urgency,
  });

  AllocationCreateCategoryState copyWith({
    StateType? type,
    StateStatus? status,
    String? message,
    Category? category,
    bool? urgency,
  }) =>
      AllocationCreateCategoryState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message,
        category: category ?? this.category,
        urgency: urgency ?? this.urgency,
      );
}
