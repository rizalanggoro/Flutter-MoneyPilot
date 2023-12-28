part of 'view.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void changeNavigation({
    required int index,
  }) =>
      emit(state.copyWith(
        navigationIndex: index,
      ));
}
