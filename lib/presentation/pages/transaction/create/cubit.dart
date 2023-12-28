part of 'view.dart';

class TransactionCreateCubit extends Cubit<TransactionCreateState> {
  final UseCaseCreateTransaction _useCaseCreateTransaction;

  TransactionCreateCubit({
    required UseCaseCreateTransaction useCaseCreateTransaction,
  })  : _useCaseCreateTransaction = useCaseCreateTransaction,
        super(TransactionCreateState());

  void changeCategory({
    required Category category,
  }) =>
      emit(state.copyWith(
        type: StateType.categoryChanged,
        category: category,
      ));

  void changeDate({
    required DateTime newDateTime,
  }) =>
      emit(state.copyWith(
        type: StateType.dateChanged,
        dateTime: newDateTime,
      ));

  void create() async {}
}
