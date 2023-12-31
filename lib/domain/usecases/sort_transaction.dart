import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/enums/sort_transaction_by.dart';
import 'package:money_pilot/core/enums/sort_type.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/transaction.dart';

class ParamSortTransaction {
  final List<Transaction> transactions;
  final SortTransactionBy sortTransactionBy;
  final SortType sortType;
  ParamSortTransaction({
    required this.transactions,
    required this.sortTransactionBy,
    required this.sortType,
  });
}

class UseCaseSortTransaction
    implements UseCase<ParamSortTransaction, List<Transaction>> {
  @override
  Future<Either<Failure, List<Transaction>>> call(
    ParamSortTransaction params,
  ) async {
    List<Transaction> result = List.of(params.transactions);

    // sorting menggunakan algoritma bubble sort
    for (var a = 0; a < result.length - 1; a++) {
      for (var b = 0; b < result.length - 1 - a; b++) {
        final current = result[b];
        final next = result[b + 1];

        if (params.sortTransactionBy == SortTransactionBy.amount) {
          // urutkan berdasarkan nominal transaksi
          if (params.sortType == SortType.asc) {
            // urutan secara menaik
            if (current.amount > next.amount) {
              result[b] = next;
              result[b + 1] = current;
            }
          } else {
            // urutan secara menurun
            if (current.amount < next.amount) {
              result[b] = next;
              result[b + 1] = current;
            }
          }
        } else {
          // urutkan berdasarkan tanggal transaksi
          if (params.sortType == SortType.asc) {
            // urutan secara menaik
            if (current.dateTime.isAfter(next.dateTime)) {
              result[b] = next;
              result[b + 1] = current;
            }
          } else {
            // urutan secara menurun
            if (current.dateTime.isBefore(next.dateTime)) {
              result[b] = next;
              result[b + 1] = current;
            }
          }
        }
      }
    }

    return Right(result);
  }
}
