import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/repositories/category.dart';

class ParamReadCategoryByKey {
  final int key;
  ParamReadCategoryByKey({
    required this.key,
  });
}

class UseCaseReadCategoryByKey
    implements UseCase<ParamReadCategoryByKey, Category> {
  final RepositoryCategory _repositoryCategory;

  UseCaseReadCategoryByKey({
    required RepositoryCategory repositoryCategory,
  }) : _repositoryCategory = repositoryCategory;

  @override
  Future<Either<Failure, Category>> call(ParamReadCategoryByKey params) async =>
      _repositoryCategory.readByKey(
        key: params.key,
      );
}
