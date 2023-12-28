part of 'view.dart';

class AllocationCreateCubit extends Cubit<AllocationCreateState> {
  final UseCaseGenerateAllocationGreedy _useCaseGenerateAllocationGreedy;
  final UseCaseGenerateAllocationExhaustive
      _useCaseGenerateAllocationExhaustive;

  AllocationCreateCubit({
    required UseCaseGenerateAllocationGreedy useCaseGenerateAllocationGreedy,
    required UseCaseGenerateAllocationExhaustive
        useCaseGenerateAllocationExhaustive,
  })  : _useCaseGenerateAllocationGreedy = useCaseGenerateAllocationGreedy,
        _useCaseGenerateAllocationExhaustive =
            useCaseGenerateAllocationExhaustive,
        super(AllocationCreateState());

  void changeAllocationAlgorithm({
    required AllocationAlgorithm algorithm,
  }) =>
      emit(state.copyWith(
        type: StateType.allocationAlgorithmChanged,
        allocationAlgorithm: algorithm,
      ));

  void changeAllocationOrder({
    required int oldIndex,
    required int newIndex,
  }) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final listAllocation = List.of(state.allocations);
    final removedItem = listAllocation.removeAt(oldIndex);

    emit(state.copyWith(
      type: StateType.allocationOrderChanged,
      allocations: listAllocation
        ..insert(
          newIndex,
          removedItem,
        ),
    ));
  }

  void startAllocation({
    required String strMaxAmount,
  }) async {
    int maxAmount = 0;
    if (strMaxAmount.isNotEmpty) {
      maxAmount = int.parse(strMaxAmount);
    }

    emit(state.copyWith(
      type: StateType.allocation,
      status: StateStatus.loading,
    ));

    final allocationResult = state.allocationAlgorithm.isGreedy
        ? await _useCaseGenerateAllocationGreedy.call(
            ParamsGenerateAllocationGreedy(
              totalAmount: maxAmount,
              allocations: state.allocations,
            ),
          )
        : await _useCaseGenerateAllocationExhaustive.call(
            ParamsGenerateAllocationExhaustive(
              maxAmount: maxAmount,
              allocations: state.allocations,
            ),
          );

    allocationResult.fold(
      (l) => emit(state.copyWith(
        type: StateType.allocation,
        status: StateStatus.failure,
        message: l.message,
      )),
      (r) => emit(state.copyWith(
        type: StateType.allocation,
        status: StateStatus.success,
        allocationsResult: r,
      )),
    );
  }
}
