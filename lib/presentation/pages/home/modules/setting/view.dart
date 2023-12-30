import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/application/service_locator.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/data/providers/local.dart';
import 'package:money_pilot/presentation/bloc/theme/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class HomeSetting extends StatelessWidget {
  const HomeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const Divider(),

          // debug,
          ListTile(
            title: Text('Delete all categories'),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}
