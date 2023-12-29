part of 'view.dart';

class HomeSettingsState {
  final StateStatus status;
  final String message;

  HomeSettingsState({
    this.status = StateStatus.initial,
    this.message = '',
  });

  HomeSettingsState copyWith({
    StateStatus? status,
    String? message,
  }) =>
      HomeSettingsState(
        status: status ?? this.status,
        message: message ?? this.message,
      );
}
