import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/repositories/category.dart';

class UseCaseUpdateCategory implements UseCase<Category, void> {
  final RepositoryCategory _repositoryCategory;

  UseCaseUpdateCategory({
    required RepositoryCategory repositoryCategory,
  }) : _repositoryCategory = repositoryCategory;

  @override
  Future<Either<Failure, void>> call(
    Category category,
  ) async {
    if (category.key == null) {
      return Left(Failure(message: 'Key kategori null!'));
    }

    final updateResult = await _repositoryCategory.update(category);

    return updateResult.fold(
      (l) => Left(Failure(message: 'Gagal mengubah kategori!')),
      (r) => const Right(null),
    );
  }
}
