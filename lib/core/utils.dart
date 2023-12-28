import 'package:flutter/material.dart';

class Utils {
  static void showSnackbar({
    required BuildContext context,
    required String message,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
      );

  static TextTheme textTheme(
    BuildContext context,
  ) =>
      Theme.of(context).textTheme;

  static ColorScheme colorScheme(
    BuildContext context,
  ) =>
      Theme.of(context).colorScheme;
}
