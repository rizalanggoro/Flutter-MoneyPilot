part of 'view.dart';

class HomeState {
  final int navigationIndex;
  HomeState({
    this.navigationIndex = 2,
  });

  HomeState copyWith({
    int? navigationIndex,
  }) =>
      HomeState(
        navigationIndex: navigationIndex ?? this.navigationIndex,
      );
}
