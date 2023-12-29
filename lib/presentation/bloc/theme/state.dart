part of 'cubit.dart';

class StateTheme {
  final bool isDarkMode;
  StateTheme({
    this.isDarkMode = false,
  });

  StateTheme copyWith({
    bool? isDarkMode,
  }) =>
      StateTheme(
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );
}
