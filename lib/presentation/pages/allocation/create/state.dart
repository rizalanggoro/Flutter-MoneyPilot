part of 'view.dart';

enum StateType {
  initial,
  allocationAlgorithmChanged,
  allocationsChanged,
  generate,
  create,
}

class AllocationCreateState {
  final StateType type;
  final StateStatus status;
  final String message;
  final AllocationAlgorithm allocationAlgorithm;
  final List<AllocationCategory> allocations;
  final List<AllocationCategory> allocationsResult;
  final SetAllocation? createdSetAllocation;

  AllocationCreateState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.message = '',
    this.allocationAlgorithm = AllocationAlgorithm.prevalent,
    this.allocations = const [],
    this.allocationsResult = const [],
    this.createdSetAllocation,
  });

  AllocationCreateState copyWith({
    StateType? type,
    StateStatus? status,
    String? message,
    AllocationAlgorithm? allocationAlgorithm,
    List<AllocationCategory>? allocations,
    List<AllocationCategory>? allocationsResult,
    SetAllocation? createdSetAllocation,
  }) =>
      AllocationCreateState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message,
        allocationAlgorithm: allocationAlgorithm ?? this.allocationAlgorithm,
        allocations: allocations ?? this.allocations,
        allocationsResult: allocationsResult ?? this.allocationsResult,
        createdSetAllocation: createdSetAllocation ?? this.createdSetAllocation,
      );
}
