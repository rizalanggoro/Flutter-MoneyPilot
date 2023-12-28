import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/category.dart';

class ParamsSyncReadCategoryByKey {
  final List<Category> categories;
  final int? key;
  ParamsSyncReadCategoryByKey({
    required this.categories,
    this.key,
  });
}

class UseCaseSyncReadCategoryByKey
    implements SyncUseCase<ParamsSyncReadCategoryByKey, Category> {
  @override
  Either<Failure, Category> call(ParamsSyncReadCategoryByKey params) {
    Category? result;
    for (final category in params.categories) {
      if (category.key == params.key) {
        result = category;
        break;
      }
    }

    if (result != null) {
      return Right(result);
    } else {
      return Left(Failure(
        message: 'Kategori tidak ditemukan!',
      ));
    }
  }
}
