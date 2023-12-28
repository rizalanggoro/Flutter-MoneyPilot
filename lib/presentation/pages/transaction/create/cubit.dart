part of 'view.dart';

class TransactionCreateCubit extends Cubit<TransactionCreateState> {
  final CubitTransaction _cubitTransaction;
  final UseCaseCreateTransaction _useCaseCreateTransaction;

  TransactionCreateCubit({
    required CubitTransaction cubitTransaction,
    required UseCaseCreateTransaction useCaseCreateTransaction,
  })  : _cubitTransaction = cubitTransaction,
        _useCaseCreateTransaction = useCaseCreateTransaction,
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

  void create({
    required String strAmount,
    required String note,
  }) async {
    emit(state.copyWith(
      type: StateType.create,
      status: StateStatus.loading,
    ));

    var amount = 0;
    if (strAmount.isNotEmpty) {
      amount = int.parse(strAmount);
    }

    final transaction = Transaction(
      amount: amount,
      note: note,
      categoryKey: state.category?.key,
      dateTime: state.dateTime,
    );
    final createResult = await _useCaseCreateTransaction.call(
      transaction,
    );

    createResult.fold(
      (l) => emit(state.copyWith(
        type: StateType.create,
        status: StateStatus.failure,
        message: l.message,
      )),
      (r) {
        final createdTransaction = transaction.copyWith(key: r);
        _cubitTransaction.add(transaction: createdTransaction);

        emit(state.copyWith(
          type: StateType.create,
          status: StateStatus.success,
        ));
      },
    );
  }
}
