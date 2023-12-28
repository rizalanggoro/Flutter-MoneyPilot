import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/transaction.dart';
import 'package:money_pilot/domain/repositories/transaction.dart';

class UseCaseCreateTransaction implements AsyncUseCase<Transaction, int> {
  final RepositoryTransaction _repositoryTransaction;

  UseCaseCreateTransaction({
    required RepositoryTransaction repositoryTransaction,
  }) : _repositoryTransaction = repositoryTransaction;

  @override
  Future<Either<Failure, int>> call(
    Transaction transaction,
  ) async {
    if (transaction.categoryKey == null) {
      return Left(
        Failure(
          message: 'Kategori belum dipilih!',
        ),
      );
    }

    final createResult = await _repositoryTransaction.create(
      transaction: transaction,
    );

    return createResult.fold(
      (l) => Left(Failure(
        message: 'Gagal membuat transaksi baru!',
      )),
      (r) => Right(r),
    );
  }
}
