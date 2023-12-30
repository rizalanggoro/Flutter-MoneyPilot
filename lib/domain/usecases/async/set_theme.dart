import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/repositories/theme.dart';

class UseCaseAsyncSetTheme implements AsyncUseCase<Brightness, void> {
  final RepositoryTheme _repositoryTheme;

  UseCaseAsyncSetTheme({
    required RepositoryTheme repositoryTheme,
  }) : _repositoryTheme = repositoryTheme;

  @override
  Future<Either<Failure, void>> call(Brightness brightness) =>
      _repositoryTheme.set(brightness: brightness);
}
