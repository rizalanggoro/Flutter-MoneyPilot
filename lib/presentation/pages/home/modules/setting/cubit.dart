part of 'view.dart';

class HomeSettingsCubit extends Cubit<HomeSettingsState> {
  HomeSettingsCubit() : super(HomeSettingsState());

  void deleteAllCategories() async {
    final result =
        await serviceLocator<ProviderLocal>().clear(name: 'categories');
    print(result);
  }
}
