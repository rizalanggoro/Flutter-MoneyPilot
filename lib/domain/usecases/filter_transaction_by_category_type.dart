import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/models/transaction.dart';

class ParamFilterTransactionByCategoryType {
  final List<Category> categories;
  final List<Transaction> transactions;
  final CategoryType categoryType;
  ParamFilterTransactionByCategoryType({
    required this.categories,
    required this.transactions,
    required this.categoryType,
  });
}

class UseCaseFilterTransactionByCategoryType
    implements
        UseCase<ParamFilterTransactionByCategoryType, List<Transaction>> {
  @override
  Future<Either<Failure, List<Transaction>>> call(
    ParamFilterTransactionByCategoryType params,
  ) async {
    CategoryType? getCategoryTypeByKey({
      required int key,
    }) {
      CategoryType? result;
      for (final category in params.categories) {
        if (category.key == key) {
          result = category.type;
          break;
        }
      }

      return result;
    }

    List<Transaction> result = [];

    for (final transaction in params.transactions) {
      if (transaction.categoryKey != null) {
        final categoryType = getCategoryTypeByKey(
          key: transaction.categoryKey!,
        );
        if (categoryType != null) {
          if (categoryType == params.categoryType) {
            result.add(transaction);
          }
        }
      }
    }

    return Right(result);
  }
}
