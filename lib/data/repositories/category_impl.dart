import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/data/providers/local.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/repositories/category.dart';

class RepositoryCategoryImpl implements RepositoryCategory {
  final ProviderLocal providerLocal;

  RepositoryCategoryImpl({
    required this.providerLocal,
  });

  @override
  Future<Either<Failure, int>> create(Category category) {
    return providerLocal.create(
      name: 'categories',
      data: category.toJson(),
    );
  }

  @override
  Future<Either<Failure, List<Category>>> read() async {
    final result = await providerLocal.read(name: 'categories');

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
  Future<Either<Failure, void>> delete({
    required int key,
  }) async {
    final result = await providerLocal.delete(
      name: 'categories',
      key: key,
    );

    return result.fold(
      (l) => Left(Failure(message: l.message)),
      (r) => const Right(null),
    );
  }
}
