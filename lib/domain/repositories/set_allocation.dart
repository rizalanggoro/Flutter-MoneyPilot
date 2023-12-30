import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/domain/models/set_allocation.dart';

abstract class RepositorySetAllocation {
  Future<Either<Failure, int>> create({
    required SetAllocation setAllocation,
  });

  Future<Either<Failure, List<SetAllocation>>> read();

  Future<Either<Failure, void>> delete({
    required int key,
  });
}
