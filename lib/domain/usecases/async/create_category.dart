import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/repositories/category.dart';

class UseCaseAsyncCreateCategory implements UseCase<Category, int> {
  final RepositoryCategory repositoryCategory;

  UseCaseAsyncCreateCategory({
    required this.repositoryCategory,
  });

  @override
  Future<Either<Failure, int>> call(
    Category newCategory,
  ) async {
    if (newCategory.name.isEmpty) {
      return Left(
        Failure(
          message: 'Nama kategori tidak boleh kosong',
        ),
      );
    }

    final readResult = await repositoryCategory.read();
    if (readResult.isRight()) {
      // linear search
      final categories = readResult.getOrElse(() => []);
      var found = false;
      for (final category in categories) {
        if (category.name.toLowerCase() == newCategory.name.toLowerCase() &&
            category.type == newCategory.type) {
          found = true;
          break;
        }
      }

      if (found) {
        return Left(
          Failure(
            message: 'Kategori dengan nama dan tipe ini telah ada sebelumnya!',
          ),
        );
      }

      // create a new category
      return repositoryCategory.create(newCategory);
    }

    return Left(
      Failure(
        message: 'Gagal membuat kategori baru!',
      ),
    );
  }
}
