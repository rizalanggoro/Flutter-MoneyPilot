part of 'cubit.dart';

class StateTheme {
  final Brightness brightness;
  StateTheme({
    this.brightness = Brightness.light,
  });

  StateTheme copyWith({
    Brightness? brightness,
  }) =>
      StateTheme(
        brightness: brightness ?? this.brightness,
      );
}
