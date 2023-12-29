import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/application/service_locator.dart';
import 'package:money_pilot/presentation/pages/allocation/create/view.dart';
import 'package:money_pilot/presentation/pages/category/create/view.dart';
import 'package:money_pilot/presentation/pages/category/manage/view.dart';
import 'package:money_pilot/presentation/pages/category/select/view.dart';
import 'package:money_pilot/presentation/pages/home/modules/transaction/view.dart';
import 'package:money_pilot/presentation/pages/home/view.dart';
import 'package:money_pilot/presentation/pages/transaction/create/view.dart';

part 'routes.dart';

sealed class RouteConfig {
  static final config = GoRouter(
    routes: _routes,
    // initialLocation: Routes.allocationCreate,
  );
  static final _routes = <GoRoute>[
    GoRoute(
      path: Routes.home,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeCubit()),
          BlocProvider(
              create: (context) => HomeTransactionCubit(
                    useCaseSyncReadCategoryByKey: serviceLocator(),
                  )),
        ],
        child: const PageHome(),
      ),
    ),

    // category
    GoRoute(
      path: Routes.categoryManage,
      builder: (context, state) => BlocProvider(
        create: (context) => CategoryManageCubit(
          categoryBloc: serviceLocator(),
          useCaseDeleteCategory: serviceLocator(),
          useCaseFilterCategoryByType: serviceLocator(),
        ),
        child: const PageCategoryManage(),
      ),
    ),
    GoRoute(
      path: Routes.categoryCreate,
      builder: (context, state) => BlocProvider(
        create: (context) => CategoryCreateCubit(
          categoryBloc: serviceLocator(),
          useCaseCreateCategory: serviceLocator(),
        ),
        child: const PageCategoryCreate(),
      ),
    ),
    GoRoute(
      path: Routes.categorySelect,
      builder: (context, state) => BlocProvider(
        create: (context) => CategorySelectCubit(
          useCaseFilterCategoryByType: serviceLocator(),
        ),
        child: PageCategorySelect(
          extra: state.extra,
        ),
      ),
    ),

    // transaction,
    GoRoute(
      path: Routes.transactionCreate,
      builder: (context, state) => BlocProvider(
        create: (context) => TransactionCreateCubit(
          cubitTransaction: serviceLocator(),
          useCaseCreateTransaction: serviceLocator(),
        ),
        child: const PageTransactionCreate(),
      ),
    ),

    // allocation,
    GoRoute(
      path: Routes.allocationCreate,
      builder: (context, state) => BlocProvider(
        create: (context) => AllocationCreateCubit(
          useCaseGenerateAllocationGreedy: serviceLocator(),
          useCaseGenerateAllocationExhaustive: serviceLocator(),
          useCaseAsyncGenerateAllocationPrevalent: serviceLocator(),
        ),
        child: const PageAllocationCreate(),
      ),
    ),
  ];
}
