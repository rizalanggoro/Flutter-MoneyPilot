import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_pilot/core/application/service_locator.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/presentation/cubit/category/cubit.dart';
import 'package:money_pilot/presentation/cubit/set_allocation/cubit.dart';
import 'package:money_pilot/presentation/cubit/theme/cubit.dart';
import 'package:money_pilot/presentation/cubit/transaction/cubit.dart';

final class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<CategoryCubit>()),
        BlocProvider(create: (context) => serviceLocator<CubitTransaction>()),
        BlocProvider(create: (context) => serviceLocator<CubitTheme>()),
        BlocProvider(create: (context) => serviceLocator<CubitSetAllocation>()),
      ],
      child: BlocBuilder<CubitTheme, StateTheme>(
        bloc: serviceLocator(),
        builder: (context, state) {
          return MaterialApp.router(
            theme: ThemeData(
              colorSchemeSeed: Colors.indigo,
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              colorSchemeSeed: Colors.indigo,
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: state.brightness == Brightness.light
                ? ThemeMode.light
                : ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            routerConfig: RouteConfig.config,
          );
        },
      ),
    );
  }
}
