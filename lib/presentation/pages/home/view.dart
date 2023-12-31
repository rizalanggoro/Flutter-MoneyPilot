import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/presentation/pages/home/modules/allocation/view.dart';
import 'package:money_pilot/presentation/pages/home/modules/setting/view.dart';
import 'package:money_pilot/presentation/pages/home/modules/transaction/view.dart';

part 'cubit.dart';
part 'state.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final _navigations = [
    // _ContentItem(
    //   title: 'Dasbor',
    //   iconData: Icons.dashboard_rounded,
    //   component: const HomeDashboard(),
    // ),
    _ContentItem(
      title: 'Transaksi',
      iconData: Icons.wallet_rounded,
      component: const HomeTransaction(),
      showFab: true,
      fabRoute: Routes.transactionCreate,
    ),
    _ContentItem(
      title: 'Alokasi',
      iconData: Icons.pie_chart_rounded,
      component: const HomeAlloaction(),
      showFab: true,
      fabRoute: Routes.allocationCreate,
    ),
    _ContentItem(
      title: 'Setelan',
      iconData: Icons.settings_rounded,
      component: const HomeSetting(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _content,
      bottomNavigationBar: _navbar,
      floatingActionButton: _fab,
    );
  }

  get _appBar => AppBar(
        title: BlocBuilder<HomeCubit, HomeState>(
          bloc: context.read<HomeCubit>(),
          builder: (context, state) => Text(
            _navigations[state.navigationIndex].title,
          ),
        ),
        actions: [
          BlocBuilder<HomeCubit, HomeState>(
            bloc: context.read<HomeCubit>(),
            builder: (context, state) => state.navigationIndex == 0
                ? IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.sort_rounded),
                  )
                : Container(),
          ),
          const SizedBox(width: 16),
        ],
      );

  get _content => BlocBuilder<HomeCubit, HomeState>(
        bloc: context.read<HomeCubit>(),
        builder: (context, state) => IndexedStack(
          index: state.navigationIndex,
          children: _navigations.map((e) => e.component).toList(),
        ),
      );

  get _navbar => BlocBuilder<HomeCubit, HomeState>(
        bloc: context.read<HomeCubit>(),
        builder: (context, state) {
          return NavigationBar(
            onDestinationSelected: (value) =>
                context.read<HomeCubit>().changeNavigation(
                      index: value,
                    ),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: state.navigationIndex,
            destinations: _navigations
                .map(
                  (e) => NavigationDestination(
                    icon: Icon(e.iconData),
                    label: e.title,
                  ),
                )
                .toList(),
          );
        },
      );

  get _fab => BlocBuilder<HomeCubit, HomeState>(
        bloc: context.read<HomeCubit>(),
        builder: (context, state) =>
            (_navigations[state.navigationIndex].showFab ?? false)
                ? FloatingActionButton(
                    onPressed: () => context.push(
                      _navigations[state.navigationIndex].fabRoute ??
                          Routes.home,
                    ),
                    child: const Icon(Icons.add_rounded),
                  )
                : Container(),
      );
}

class _ContentItem {
  final String title;
  final IconData iconData;
  final Widget component;
  final bool? showFab;
  final String? fabRoute;
  _ContentItem({
    required this.title,
    required this.iconData,
    required this.component,
    this.showFab,
    this.fabRoute,
  });
}
