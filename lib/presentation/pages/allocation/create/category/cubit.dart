part of 'view.dart';

class AllocationCreateCategoryCubit
    extends Cubit<AllocationCreateCategoryState> {
  AllocationCreateCategoryCubit() : super(AllocationCreateCategoryState());

  void initialize({
    required Allocation allocation,
  }) =>
      emit(state.copyWith(
        category: allocation.category,
        urgency: allocation.isUrgent ?? false,
      ));

  void changeCategory({
    required Category category,
  }) =>
      emit(state.copyWith(
        type: StateType.categoryChanged,
        category: category,
      ));

  void changeUrgency({
    required bool urgency,
  }) =>
      emit(state.copyWith(
        type: StateType.urgencyChanged,
        urgency: urgency,
      ));

  void done() {
    if (state.category == null) {
      return emit(state.copyWith(
        type: StateType.create,
        status: StateStatus.failure,
        message: 'Kategori belum dipilih!',
      ));
    }

    return emit(state.copyWith(
      type: StateType.create,
      status: StateStatus.success,
    ));
  }
}
