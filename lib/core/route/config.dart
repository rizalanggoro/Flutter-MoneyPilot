import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/application/service_locator.dart';
import 'package:money_pilot/presentation/pages/allocation/create/category/view.dart';
import 'package:money_pilot/presentation/pages/allocation/create/view.dart';
import 'package:money_pilot/presentation/pages/allocation/detail/view.dart';
import 'package:money_pilot/presentation/pages/category/create/view.dart';
import 'package:money_pilot/presentation/pages/category/manage/view.dart';
import 'package:money_pilot/presentation/pages/category/select/view.dart';
import 'package:money_pilot/presentation/pages/home/modules/transaction/view.dart';
import 'package:money_pilot/presentation/pages/home/view.dart';
import 'package:money_pilot/presentation/pages/transaction/create/view.dart';
import 'package:money_pilot/presentation/pages/transaction/detail/view.dart';

part 'routes.dart';

sealed class RouteConfig {
  static final config = GoRouter(
    routes: _routes,
    // initialLocation: Routes.transactionDetail,
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
              useCaseFilterTransactionByCategoryType: serviceLocator(),
              useCaseSortTransaction: serviceLocator(),
            ),
          ),
        ],
        child: const PageHome(),
      ),
    ),

    // category
    GoRoute(
      path: Routes.categoryManage,
      builder: (context, state) => BlocProvider(
        create: (context) => CategoryManageCubit(
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
          useCaseAsyncUpdateCategory: serviceLocator(),
        ),
        child: PageCategoryCreate(
          extra: state.extra,
        ),
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
    GoRoute(
      path: Routes.transactionDetail,
      builder: (context, state) => BlocProvider(
        create: (context) => TransactionDetailCubit(
          useCaseReadCategoryByKey: serviceLocator(),
          useCaseDeleteTransaction: serviceLocator(),
        ),
        child: PageTransactionDetail(
          extra: state.extra,
        ),
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
          useCaseCreateSetAllocation: serviceLocator(),
        ),
        child: const PageAllocationCreate(),
      ),
    ),
    GoRoute(
      path: Routes.allocationCreateCategory,
      builder: (context, state) => BlocProvider(
        create: (context) => AllocationCreateCategoryCubit(),
        child: PageAllocationCreateCategory(
          extra: state.extra,
        ),
      ),
    ),
    GoRoute(
      path: Routes.allocationDetail,
      builder: (context, state) => BlocProvider(
        create: (context) => AllocationDetailCubit(
          useCaseReadCategoryByKey: serviceLocator(),
          useCaseDeleteSetAllocation: serviceLocator(),
        ),
        child: PageAllocationDetail(
          extra: state.extra,
        ),
      ),
    ),
  ];
}
