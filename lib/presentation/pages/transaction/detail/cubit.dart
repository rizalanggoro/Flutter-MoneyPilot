part of 'view.dart';

class TransactionDetailCubit extends Cubit<TransactionDetailState> {
  final UseCaseReadCategoryByKey _useCaseReadCategoryByKey;
  final UseCaseDeleteTransaction _useCaseDeleteTransaction;

  TransactionDetailCubit({
    required UseCaseReadCategoryByKey useCaseReadCategoryByKey,
    required UseCaseDeleteTransaction useCaseDeleteTransaction,
  })  : _useCaseReadCategoryByKey = useCaseReadCategoryByKey,
        _useCaseDeleteTransaction = useCaseDeleteTransaction,
        super(TransactionDetailState());

  void delete({
    Transaction? transaction,
  }) async {
    if (transaction?.key != null) {
      emit(state.copyWith(
        type: StateType.delete,
        status: StateStatus.loading,
      ));

      final deleteResult = await _useCaseDeleteTransaction.call(
        ParamDeleteTransaction(
          key: transaction!.key!,
        ),
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
          deletedTransaction: transaction,
        )),
      );
    }
  }

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
}
