import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:money_pilot/core/failure/failure.dart';

class ProviderLocal {
  Future<Either<Failure, int>> create({
    required String name,
    required Map<String, dynamic> data,
  }) async {
    try {
      final box = await Hive.openBox(name);
      final key = await box.add(data);
      return Right(key);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<dynamic>>> read({
    required String name,
  }) async {
    try {
      final box = await Hive.openBox(name);

      return Right(box.toMap().entries.map((e) {
        return {...e.value, 'key': e.key};
      }).toList());
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> delete({
    required String name,
    required int key,
  }) async {
    try {
      final box = await Hive.openBox(name);
      await box.delete(key);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> clear({
    required String name,
  }) async {
    try {
      final box = await Hive.openBox(name);
      await box.clear();
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
