import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/repositories/set_allocation.dart';

class ParamDeleteSetAllocation {
  final int key;
  ParamDeleteSetAllocation({
    required this.key,
  });
}

class UseCaseDeleteSetAllocation
    implements UseCase<ParamDeleteSetAllocation, void> {
  final RepositorySetAllocation _repositorySetAllocation;

  UseCaseDeleteSetAllocation({
    required RepositorySetAllocation repositorySetAllocation,
  }) : _repositorySetAllocation = repositorySetAllocation;

  @override
  Future<Either<Failure, void>> call(
    ParamDeleteSetAllocation params,
  ) async =>
      _repositorySetAllocation.delete(
        key: params.key,
      );
}
