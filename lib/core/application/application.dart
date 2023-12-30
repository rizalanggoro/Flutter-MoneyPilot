import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_pilot/core/application/service_locator.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/presentation/bloc/category/cubit.dart';
import 'package:money_pilot/presentation/bloc/theme/cubit.dart';
import 'package:money_pilot/presentation/bloc/transaction/cubit.dart';

final class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<CategoryCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CubitTransaction>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CubitTheme>(),
        ),
      ],
      child: BlocBuilder<CubitTheme, StateTheme>(
        bloc: serviceLocator(),
        builder: (context, state) {
          return MaterialApp.router(
            theme: ThemeData(
              colorSchemeSeed: Colors.indigo,
              useMaterial3: true,
              textTheme: GoogleFonts.interTextTheme(),
              brightness: state.brightness,
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: RouteConfig.config,
          );
        },
      ),
    );
  }
}
