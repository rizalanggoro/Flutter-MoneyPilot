import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';

abstract class UseCase<Params, Result> {
  FutureOr<Either<Failure, Result>> call(Params params);
}

class NoParams {}
