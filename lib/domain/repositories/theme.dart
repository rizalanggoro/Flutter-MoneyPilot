import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:money_pilot/core/failure/failure.dart';

abstract class RepositoryTheme {
  Future<Either<Failure, void>> set({
    required Brightness brightness,
  });

  Future<Either<Failure, Brightness>> get();
}
