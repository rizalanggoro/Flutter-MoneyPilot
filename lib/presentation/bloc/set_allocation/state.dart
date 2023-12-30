part of 'cubit.dart';

class StateSetAllocation {
  final StateStatus status;
  final List<SetAllocation> setAllocations;

  StateSetAllocation({
    this.status = StateStatus.initial,
    this.setAllocations = const [],
  });

  StateSetAllocation copyWith({
    StateStatus? status,
    List<SetAllocation>? setAllocations,
  }) =>
      StateSetAllocation(
        status: status ?? this.status,
        setAllocations: setAllocations ?? this.setAllocations,
      );
}
