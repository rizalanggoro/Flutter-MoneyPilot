import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/transaction.dart';
import 'package:money_pilot/domain/repositories/transaction.dart';

class UseCaseCreateTransaction implements AsyncUseCase<Transaction, void> {
  final RepositoryTransaction _repositoryTransaction;

  UseCaseCreateTransaction({
    required RepositoryTransaction repositoryTransaction,
  }) : _repositoryTransaction = repositoryTransaction;

  @override
  Future<Either<Failure, void>> call(
    Transaction transaction,
  ) async {
    // TODO: implement call
    throw UnimplementedError();
  }
}
