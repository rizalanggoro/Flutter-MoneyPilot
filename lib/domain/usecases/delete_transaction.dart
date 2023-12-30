import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/repositories/transaction.dart';

class ParamDeleteTransaction {
  final int key;
  ParamDeleteTransaction({
    required this.key,
  });
}

class UseCaseDeleteTransaction
    implements UseCase<ParamDeleteTransaction, void> {
  final RepositoryTransaction _repositoryTransaction;

  UseCaseDeleteTransaction({
    required RepositoryTransaction repositoryTransaction,
  }) : _repositoryTransaction = repositoryTransaction;

  @override
  FutureOr<Either<Failure, void>> call(
    ParamDeleteTransaction params,
  ) async =>
      _repositoryTransaction.delete(key: params.key);
}
