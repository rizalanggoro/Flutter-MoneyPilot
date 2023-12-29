part of 'view.dart';

enum StateType {
  initial,
  allocationAlgorithmChanged,
  allocationOrderChanged,
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
    this.allocations = const [
      Allocation(
        amount: 500000,
        category: Category(
          name: 'Makan',
          type: CategoryType.expense,
        ),
      ),
      Allocation(
        amount: 120000,
        category: Category(
          name: 'Hiburan',
          type: CategoryType.expense,
        ),
      ),
      Allocation(
        amount: 50000,
        category: Category(
          name: 'Tabungan',
          type: CategoryType.expense,
        ),
      ),
      Allocation(
        amount: 400000,
        category: Category(
          name: 'Transportasi',
          type: CategoryType.expense,
        ),
      ),
      Allocation(
        amount: 50000,
        category: Category(
          name: 'Listrik',
          type: CategoryType.expense,
        ),
        isUrgent: true,
      ),
    ],
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
