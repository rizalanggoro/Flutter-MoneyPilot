import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/domain/models/category.dart';

abstract class RepositoryCategory {
  Future<Either<Failure, int>> create(Category category);

  Future<Either<Failure, List<Category>>> read();

  Future<Either<Failure, Category>> readByKey({
    required int key,
  });

  Future<Either<Failure, void>> update(Category category);

  Future<Either<Failure, void>> delete({
    required int key,
  });
}
