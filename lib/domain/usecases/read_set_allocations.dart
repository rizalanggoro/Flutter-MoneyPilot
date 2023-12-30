import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/set_allocation.dart';
import 'package:money_pilot/domain/repositories/set_allocation.dart';

class UseCaseReadSetAllocations implements UseCase<void, List<SetAllocation>> {
  final RepositorySetAllocation _repositorySetAllocation;

  UseCaseReadSetAllocations({
    required RepositorySetAllocation repositorySetAllocation,
  }) : _repositorySetAllocation = repositorySetAllocation;

  @override
  FutureOr<Either<Failure, List<SetAllocation>>> call(void _) async {
    final readResult = await _repositorySetAllocation.read();
    return readResult.fold(
      (l) => Left(Failure(
        message: 'Gagal membaca set alokasi!',
      )),
      (r) => Right(r),
    );
  }
}
