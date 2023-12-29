import 'package:bloc/bloc.dart';

part 'state.dart';

class CubitTheme extends Cubit<StateTheme> {
  CubitTheme() : super(StateTheme());

  void changeToDark() => emit(state.copyWith(
        isDarkMode: true,
      ));

  void changeToLight() => emit(state.copyWith(
        isDarkMode: false,
      ));
}
