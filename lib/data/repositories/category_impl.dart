import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/data/providers/local.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/repositories/category.dart';

class RepositoryCategoryImpl implements RepositoryCategory {
  final ProviderLocal _providerLocal;

  RepositoryCategoryImpl({
    required ProviderLocal providerLocal,
  }) : _providerLocal = providerLocal;

  @override
  Future<Either<Failure, int>> create(Category category) {
    return _providerLocal.add(
      name: 'categories',
      data: category.toJson(),
    );
  }

  @override
  Future<Either<Failure, List<Category>>> read() async {
    final result = await _providerLocal.readEntries(name: 'categories');

    if (result.isRight()) {
      final List<Category> categories = result
          .getOrElse(() => [])
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return Right(categories);
    }

    return Left(Failure(message: 'Gagal membaca'));
  }

  @override
  Future<Either<Failure, void>> update(
    Category category,
  ) async {
    if (category.key == null) {
      return Left(Failure(message: 'Gagal mengubah kategori!'));
    }

    return _providerLocal.put(
      name: 'categories',
      key: category.key!,
      data: category.toJson(),
    );
  }

  @override
  Future<Either<Failure, void>> delete({
    required int key,
  }) async {
    final result = await _providerLocal.delete(
      name: 'categories',
      key: key,
    );

    return result.fold(
      (l) => Left(Failure(message: l.message)),
      (r) => const Right(null),
    );
  }
}
