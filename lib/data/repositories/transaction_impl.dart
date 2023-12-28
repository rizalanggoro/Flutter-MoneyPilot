import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/data/providers/local.dart';
import 'package:money_pilot/domain/models/transaction.dart';
import 'package:money_pilot/domain/repositories/transaction.dart';

class RepositoryTransactionImpl implements RepositoryTransaction {
  final ProviderLocal _providerLocal;

  RepositoryTransactionImpl({
    required ProviderLocal providerLocal,
  }) : _providerLocal = providerLocal;

  @override
  Future<Either<Failure, void>> create({
    required Transaction transaction,
  }) async {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Transaction>>> read() async {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> delete({
    required String key,
  }) async {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
