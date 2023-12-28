import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/repositories/category.dart';

class UseCaseDeleteCategory implements AsyncUseCase<Category, void> {
  final RepositoryCategory repositoryCategory;

  UseCaseDeleteCategory({
    required this.repositoryCategory,
  });

  @override
  Future<Either<Failure, void>> call(Category category) async {
    if (category.key == null) {
      return Left(
        Failure(
          message: 'Key kategori null!',
        ),
      );
    }

    final deleteResult = await repositoryCategory.delete(
      key: category.key!,
    );

    if (deleteResult.isRight()) {
      return const Right(null);
    }

    return Left(
      Failure(
        message: 'Gagal menghapus kategori!',
      ),
    );
  }
}
