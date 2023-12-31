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
  Future<Either<Failure, int>> create({
    required Transaction transaction,
  }) async =>
      _providerLocal.add(
        name: 'transactions',
        data: transaction.toJson(),
      );

  @override
  Future<Either<Failure, List<Transaction>>> read() async {
    final readResult = await _providerLocal.readEntries(name: 'transactions');
    if (readResult.isRight()) {
      final List<Transaction> transactions = readResult
          .getOrElse(() => [])
          .map((e) => Transaction.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return Right(transactions);
    }

    return Left(Failure(message: 'Gagal membaca data transaksi!'));
  }

  @override
  Future<Either<Failure, void>> delete({
    required int key,
  }) async {
    final deleteResult = await _providerLocal.delete(
      name: 'transactions',
      key: key,
    );
    return deleteResult.fold(
      (l) => Left(Failure(
        message: 'Gagal menghapus transaksi!',
      )),
      (r) => const Right(null),
    );
  }
}
