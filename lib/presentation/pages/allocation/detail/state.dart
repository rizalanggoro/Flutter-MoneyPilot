part of 'view.dart';

enum StateType {
  initial,
  delete,
}

class AllocationDetailState {
  final StateType type;
  final StateStatus status;
  final String message;
  final SetAllocation? deletedSetAllocation;

  AllocationDetailState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.message = '',
    this.deletedSetAllocation,
  });

  AllocationDetailState copyWith({
    StateType? type,
    StateStatus? status,
    String? message,
    SetAllocation? deletedSetAllocation,
  }) =>
      AllocationDetailState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message,
        deletedSetAllocation: deletedSetAllocation ?? this.deletedSetAllocation,
      );
}
