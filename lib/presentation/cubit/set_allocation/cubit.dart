import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/domain/models/set_allocation.dart';
import 'package:money_pilot/domain/usecases/read_set_allocations.dart';

part 'state.dart';

class CubitSetAllocation extends Cubit<StateSetAllocation> {
  final UseCaseReadSetAllocations _useCaseReadSetAllocations;

  CubitSetAllocation({
    required UseCaseReadSetAllocations useCaseReadSetAllocations,
  })  : _useCaseReadSetAllocations = useCaseReadSetAllocations,
        super(StateSetAllocation());

  void initialize() async {
    emit(state.copyWith(status: StateStatus.loading));
    final readResult = await _useCaseReadSetAllocations.call(null);
    readResult.fold(
      (l) => emit(state.copyWith(status: StateStatus.success)),
      (r) => emit(state.copyWith(
        status: StateStatus.success,
        setAllocations: r,
      )),
    );
  }

  void add({
    required SetAllocation setAllocation,
  }) {
    emit(state.copyWith(
      setAllocations: List.of(state.setAllocations)..add(setAllocation),
    ));
  }

  void remove({
    required int key,
  }) {
    emit(state.copyWith(status: StateStatus.loading));

    // linear search untuk mencari set alokasi
    // berdasarkan key
    var foundIndex = -1;
    for (final (index, setAllocation) in state.setAllocations.indexed) {
      if (setAllocation.key == key) {
        foundIndex = index;
        break;
      }
    }

    if (foundIndex != -1) {
      emit(state.copyWith(
        status: StateStatus.success,
        setAllocations: List.of(state.setAllocations)..removeAt(foundIndex),
      ));
    } else {
      emit(state.copyWith(status: StateStatus.success));
    }
  }
}
