import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_pilot/domain/usecases/get_theme.dart';
import 'package:money_pilot/domain/usecases/set_theme.dart';

part 'state.dart';

class CubitTheme extends Cubit<StateTheme> {
  final UseCaseAsyncSetTheme _useCaseAsyncSetTheme;
  final UseCaseAsyncGetTheme _useCaseAsyncGetTheme;

  CubitTheme({
    required UseCaseAsyncSetTheme useCaseAsyncSetTheme,
    required UseCaseAsyncGetTheme useCaseAsyncGetTheme,
  })  : _useCaseAsyncSetTheme = useCaseAsyncSetTheme,
        _useCaseAsyncGetTheme = useCaseAsyncGetTheme,
        super(StateTheme());

  Future<void> initialize() async {
    final getResult = await _useCaseAsyncGetTheme.call(null);
    getResult.fold(
      (l) => log(l.message),
      (r) => emit(state.copyWith(
        brightness: r,
      )),
    );
  }

  void changeToDark() async {
    final setResult = await _useCaseAsyncSetTheme.call(Brightness.dark);
    setResult.fold(
      (l) => log(l.message),
      (r) => emit(state.copyWith(
        brightness: Brightness.dark,
      )),
    );
  }

  void changeToLight() async {
    final setResult = await _useCaseAsyncSetTheme.call(Brightness.light);
    setResult.fold(
      (l) => log(l.message),
      (r) => emit(state.copyWith(
        brightness: Brightness.light,
      )),
    );
  }
}
