import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/transaction.dart';
import 'package:money_pilot/domain/repositories/transaction.dart';

class UseCaseReadTransactions implements UseCase<void, List<Transaction>> {
  final RepositoryTransaction _repositoryTransaction;
  UseCaseReadTransactions({
    required RepositoryTransaction repositoryTransaction,
  }) : _repositoryTransaction = repositoryTransaction;

  @override
  Future<Either<Failure, List<Transaction>>> call(void _) async =>
      _repositoryTransaction.read();
}
