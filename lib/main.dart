import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_pilot/core/application/application.dart';
import 'package:money_pilot/core/application/bloc_observer.dart';
import 'package:money_pilot/core/application/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  if (Platform.isAndroid) {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  await Hive.initFlutter();
  await initializeServiceLocator();

  runApp(const Application());
}
