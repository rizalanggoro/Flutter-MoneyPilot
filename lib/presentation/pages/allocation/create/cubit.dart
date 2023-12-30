part of 'view.dart';

class AllocationCreateCubit extends Cubit<AllocationCreateState> {
  final UseCaseGenerateAllocationGreedy _useCaseGenerateAllocationGreedy;
  final UseCaseGenerateAllocationExhaustive
      _useCaseGenerateAllocationExhaustive;
  final UseCaseAsyncGenerateAllocationPrevalent
      _useCaseAsyncGenerateAllocationPrevalent;
  final UseCaseCreateSetAllocation _useCaseCreateSetAllocation;

  AllocationCreateCubit({
    required UseCaseGenerateAllocationGreedy useCaseGenerateAllocationGreedy,
    required UseCaseGenerateAllocationExhaustive
        useCaseGenerateAllocationExhaustive,
    required UseCaseAsyncGenerateAllocationPrevalent
        useCaseAsyncGenerateAllocationPrevalent,
    required UseCaseCreateSetAllocation useCaseCreateSetAllocation,
  })  : _useCaseGenerateAllocationGreedy = useCaseGenerateAllocationGreedy,
        _useCaseGenerateAllocationExhaustive =
            useCaseGenerateAllocationExhaustive,
        _useCaseAsyncGenerateAllocationPrevalent =
            useCaseAsyncGenerateAllocationPrevalent,
        _useCaseCreateSetAllocation = useCaseCreateSetAllocation,
        super(AllocationCreateState());

  void changeAllocationAlgorithm({
    required AllocationAlgorithm algorithm,
  }) =>
      emit(state.copyWith(
        type: StateType.allocationAlgorithmChanged,
        allocationAlgorithm: algorithm,
      ));

  void addAllocation({
    required AllocationCategory allocation,
  }) =>
      emit(state.copyWith(
        type: StateType.allocationsChanged,
        allocations: List.of(state.allocations)..add(allocation),
      ));

  void updateAllocation({
    required int index,
    required AllocationCategory allocation,
  }) =>
      emit(state.copyWith(
        type: StateType.allocationsChanged,
        allocations: List.of(state.allocations)
          ..removeAt(index)
          ..insert(index, allocation),
      ));

  void removeAllocation({
    required int index,
  }) =>
      emit(state.copyWith(
        type: StateType.allocationsChanged,
        allocations: List.of(state.allocations)..removeAt(index),
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
      type: StateType.allocationsChanged,
      allocations: listAllocation
        ..insert(
          newIndex,
          removedItem,
        ),
    ));
  }

  void generate({
    required String strMaxAmount,
  }) async {
    int maxAmount = 0;
    if (strMaxAmount.isNotEmpty) {
      maxAmount = int.parse(strMaxAmount);
    }

    emit(state.copyWith(
      type: StateType.generate,
      status: StateStatus.loading,
    ));

    final allocationResult = state.allocationAlgorithm.isGreedy
        ? await _useCaseGenerateAllocationGreedy.call(
            ParamsGenerateAllocationGreedy(
              maxAmount: maxAmount,
              allocations: state.allocations,
            ),
          )
        : state.allocationAlgorithm.isExhaustive
            ? await _useCaseGenerateAllocationExhaustive.call(
                ParamsGenerateAllocationExhaustive(
                  maxAmount: maxAmount,
                  allocations: state.allocations,
                ),
              )
            : await _useCaseAsyncGenerateAllocationPrevalent.call(
                ParamsGenerateAllocationPrevalent(
                  maxAmount: maxAmount,
                  allocations: state.allocations,
                ),
              );

    allocationResult.fold(
      (l) => emit(state.copyWith(
        type: StateType.generate,
        status: StateStatus.failure,
        message: l.message,
      )),
      (r) => emit(state.copyWith(
        type: StateType.generate,
        status: StateStatus.success,
        allocationsResult: r,
      )),
    );
  }

  void createSetAllocation({
    required String title,
    required String strMaxAmount,
  }) async {
    int maxAmount = 0;
    if (strMaxAmount.isNotEmpty) {
      maxAmount = int.parse(strMaxAmount);
    }

    emit(state.copyWith(
      type: StateType.create,
      status: StateStatus.loading,
    ));

    final setAllocation = SetAllocation(
      title: title,
      maxAmount: maxAmount,
      algorithm: state.allocationAlgorithm,
      setAllocations: state.allocations
          .map(
            (e) => SetAllocationItem(
              amount: e.amount,
              categoryKey: e.category.key ?? -1,
              density: e.density,
              isUrgent: e.isUrgent,
            ),
          )
          .toList(),
    );

    final createResult = await _useCaseCreateSetAllocation.call(
      ParamCreateSetAllocation(
        setAllocation: setAllocation,
      ),
    );

    createResult.fold(
      (l) => emit(state.copyWith(
        type: StateType.create,
        status: StateStatus.failure,
        message: l.message,
      )),
      (r) => emit(state.copyWith(
        type: StateType.create,
        status: StateStatus.success,
        createdSetAllocation: setAllocation.copyWith(key: r),
      )),
    );
  }
}
