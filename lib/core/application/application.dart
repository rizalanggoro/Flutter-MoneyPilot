import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_pilot/core/application/service_locator.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/presentation/bloc/category/category_bloc.dart';

final class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<CategoryBloc>(),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: RouteConfig.config,
      ),
    );
  }
}
