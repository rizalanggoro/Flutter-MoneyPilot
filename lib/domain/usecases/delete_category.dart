import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/repositories/category.dart';

class ParamDeleteCategory {
  final int key;
  ParamDeleteCategory({
    required this.key,
  });
}

class UseCaseDeleteCategory implements UseCase<ParamDeleteCategory, void> {
  final RepositoryCategory _repositoryCategory;

  UseCaseDeleteCategory({
    required RepositoryCategory repositoryCategory,
  }) : _repositoryCategory = repositoryCategory;

  @override
  Future<Either<Failure, void>> call(
    ParamDeleteCategory params,
  ) async {
    final deleteResult = await _repositoryCategory.delete(
      key: params.key,
    );

    return deleteResult.fold(
      (l) => Left(Failure(message: 'Gagal menghapus kategori!')),
      (r) => const Right(null),
    );
  }
}
