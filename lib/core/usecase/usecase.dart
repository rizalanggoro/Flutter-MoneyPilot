import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';

abstract class AsyncUseCase<Params, Result> {
  Future<Either<Failure, Result>> call(Params params);
}

abstract class SyncUseCase<Params, Result> {
  Either<Failure, Result> call(Params params);
}

class NoParams {}
