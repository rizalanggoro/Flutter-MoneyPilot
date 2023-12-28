import 'dart:developer';

import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    log('[${bloc.runtimeType}] onChange: ${change.currentState.toString()} -> ${change.nextState.toString()}');
  }
}
