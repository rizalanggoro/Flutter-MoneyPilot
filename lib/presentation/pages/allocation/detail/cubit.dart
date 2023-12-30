part of 'view.dart';

class AllocationDetailCubit extends Cubit<AllocationDetailState> {
  final UseCaseReadCategoryByKey _useCaseReadCategoryByKey;
  final UseCaseDeleteSetAllocation _useCaseDeleteSetAllocation;

  AllocationDetailCubit({
    required UseCaseReadCategoryByKey useCaseReadCategoryByKey,
    required UseCaseDeleteSetAllocation useCaseDeleteSetAllocation,
  })  : _useCaseReadCategoryByKey = useCaseReadCategoryByKey,
        _useCaseDeleteSetAllocation = useCaseDeleteSetAllocation,
        super(AllocationDetailState());

  Future<Category?> readCategoryByKey({
    required int key,
  }) async {
    final readResult = await _useCaseReadCategoryByKey.call(
      ParamReadCategoryByKey(
        key: key,
      ),
    );

    return readResult.fold(
      (l) => null,
      (r) => r,
    );
  }

  void delete({
    required SetAllocation setAllocation,
  }) async {
    if (setAllocation.key != null) {
      emit(state.copyWith(
        type: StateType.delete,
        status: StateStatus.loading,
      ));

      final deleteResult = await _useCaseDeleteSetAllocation.call(
        ParamDeleteSetAllocation(key: setAllocation.key!),
      );

      deleteResult.fold(
        (l) => emit(state.copyWith(
          type: StateType.delete,
          status: StateStatus.failure,
          message: l.message,
        )),
        (r) => emit(state.copyWith(
          type: StateType.delete,
          status: StateStatus.success,
          deletedSetAllocation: setAllocation,
        )),
      );
    }
  }
}
