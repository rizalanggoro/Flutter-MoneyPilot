import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/domain/models/transaction.dart';

abstract class RepositoryTransaction {
  Future<Either<Failure, void>> create({
    required Transaction transaction,
  });

  Future<Either<Failure, List<Transaction>>> read();

  Future<Either<Failure, void>> delete({
    required String key,
  });
}
