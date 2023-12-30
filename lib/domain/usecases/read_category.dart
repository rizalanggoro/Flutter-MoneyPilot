import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/repositories/category.dart';

class UseCaseReadCategory implements UseCase<NoParams, List<Category>> {
  final RepositoryCategory _repositoryCategory;

  UseCaseReadCategory({
    required RepositoryCategory repositoryCategory,
  }) : _repositoryCategory = repositoryCategory;

  @override
  Future<Either<Failure, List<Category>>> call(
    NoParams params,
  ) async =>
      _repositoryCategory.read();
}
