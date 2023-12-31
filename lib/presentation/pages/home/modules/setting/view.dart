import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/application/service_locator.dart';
import 'package:money_pilot/core/debug/seeder_categories.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/data/providers/local.dart';
import 'package:money_pilot/presentation/bloc/theme/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class HomeSetting extends StatelessWidget {
  const HomeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar,
      body: ListView(
        children: [
          BlocBuilder<CubitTheme, StateTheme>(
            bloc: context.read<CubitTheme>(),
            builder: (context, state) {
              return SwitchListTile(
                value: state.brightness == Brightness.dark,
                onChanged: (value) => value
                    ? context.read<CubitTheme>().changeToDark()
                    : context.read<CubitTheme>().changeToLight(),
                title: const Text('Mode gelap'),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.category_rounded),
            ),
            title: const Text('Kategori'),
            subtitle: const Text(
              'Buat, ubah, dan hapus kategori transaksi',
            ),
            onTap: () => context.push(Routes.categoryManage),
          ),

          if (kDebugMode) const Divider(),

          // debug,
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 8,
              ),
              child: Text(
                'Debug',
                style: Utils.textTheme(context).titleMedium?.copyWith(
                      color: Utils.colorScheme(context).onBackground,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          if (kDebugMode)
            ListTile(
              title: const Text('Seeder categories'),
              onTap: () => DebugSeederCategories().call(),
            ),
        ],
      ),
    );
  }

  get _appbar => AppBar(title: const Text('Setelan'));
}
