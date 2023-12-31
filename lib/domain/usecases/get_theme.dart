import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/repositories/theme.dart';

class UseCaseAsyncGetTheme implements UseCase<void, Brightness> {
  final RepositoryTheme _repositoryTheme;
  UseCaseAsyncGetTheme({
    required RepositoryTheme repositoryTheme,
  }) : _repositoryTheme = repositoryTheme;

  @override
  Future<Either<Failure, Brightness>> call(void _) => _repositoryTheme.get();
}
