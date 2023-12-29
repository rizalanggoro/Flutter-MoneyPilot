part of 'view.dart';

enum StateType {
  initial,
  allocationAlgorithmChanged,
  allocationsChanged,
  allocation,
}

class AllocationCreateState {
  final StateType type;
  final StateStatus status;
  final String message;
  final AllocationAlgorithm allocationAlgorithm;
  final List<Allocation> allocations;
  final List<Allocation> allocationsResult;

  AllocationCreateState({
    this.type = StateType.initial,
    this.status = StateStatus.initial,
    this.message = '',
    this.allocationAlgorithm = AllocationAlgorithm.prevalent,
    this.allocations = const [],
    this.allocationsResult = const [],
  });

  AllocationCreateState copyWith({
    StateType? type,
    StateStatus? status,
    String? message,
    AllocationAlgorithm? allocationAlgorithm,
    List<Allocation>? allocations,
    List<Allocation>? allocationsResult,
  }) =>
      AllocationCreateState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message,
        allocationAlgorithm: allocationAlgorithm ?? this.allocationAlgorithm,
        allocations: allocations ?? this.allocations,
        allocationsResult: allocationsResult ?? this.allocationsResult,
      );
}
