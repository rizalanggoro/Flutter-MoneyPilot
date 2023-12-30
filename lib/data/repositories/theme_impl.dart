import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/data/providers/local.dart';
import 'package:money_pilot/domain/repositories/theme.dart';

class RepositoryThemeImpl implements RepositoryTheme {
  final ProviderLocal _providerLocal;

  RepositoryThemeImpl({
    required ProviderLocal providerLocal,
  }) : _providerLocal = providerLocal;

  @override
  Future<Either<Failure, void>> set({
    required Brightness brightness,
  }) async {
    final putResult = await _providerLocal.put(
      name: 'theme',
      key: 'brightness',
      data: brightness == Brightness.light ? 'light' : 'dark',
    );
    return putResult.fold(
      (l) => Left(Failure(message: 'Gagal menyetel tema! [${l.message}]')),
      (r) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, Brightness>> get() async {
    final readResult = await _providerLocal.readEntry(
      name: 'theme',
      key: 'brightness',
      defaultValue: 'light',
    );

    return readResult.fold(
      (l) => Left(Failure(message: 'Gagal membaca tema! [${l.message}]')),
      (r) => Right(
        r == 'light' ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
