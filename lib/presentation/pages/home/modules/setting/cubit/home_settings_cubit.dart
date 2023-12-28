import 'package:bloc/bloc.dart';
import 'package:money_pilot/core/application/service_locator.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/data/providers/local.dart';

part 'home_settings_state.dart';

class HomeSettingsCubit extends Cubit<HomeSettingsState> {
  HomeSettingsCubit() : super(HomeSettingsState());

  void deleteAllCategories() async {
    final result =
        await serviceLocator<ProviderLocal>().clear(name: 'categories');
    print(result);
  }
}
