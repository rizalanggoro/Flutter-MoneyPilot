import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/set_allocation.dart';
import 'package:money_pilot/domain/repositories/set_allocation.dart';

class ParamCreateSetAllocation {
  final SetAllocation setAllocation;
  ParamCreateSetAllocation({
    required this.setAllocation,
  });
}

class UseCaseCreateSetAllocation
    implements UseCase<ParamCreateSetAllocation, int> {
  final RepositorySetAllocation _repositorySetAllocation;

  UseCaseCreateSetAllocation({
    required RepositorySetAllocation repositorySetAllocation,
  }) : _repositorySetAllocation = repositorySetAllocation;

  @override
  Future<Either<Failure, int>> call(
    ParamCreateSetAllocation params,
  ) async {
    if (params.setAllocation.setAllocations.isEmpty) {
      return Left(Failure(
        message: 'Tidak ada alokasi!',
      ));
    }

    final createResult = await _repositorySetAllocation.create(
      setAllocation: params.setAllocation,
    );
    return createResult.fold(
      (l) => Left(Failure(
        message: 'Gagal menambahkan set alokasi! [${l.message}]',
      )),
      (r) => Right(r),
    );
  }
}
