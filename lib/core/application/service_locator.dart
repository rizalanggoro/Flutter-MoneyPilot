import 'package:get_it/get_it.dart';
import 'package:money_pilot/data/providers/local.dart';
import 'package:money_pilot/data/repositories/category_impl.dart';
import 'package:money_pilot/data/repositories/set_allocation_impl.dart';
import 'package:money_pilot/data/repositories/theme_impl.dart';
import 'package:money_pilot/data/repositories/transaction_impl.dart';
import 'package:money_pilot/domain/repositories/category.dart';
import 'package:money_pilot/domain/repositories/set_allocation.dart';
import 'package:money_pilot/domain/repositories/theme.dart';
import 'package:money_pilot/domain/repositories/transaction.dart';
import 'package:money_pilot/domain/usecases/async/create_category.dart';
import 'package:money_pilot/domain/usecases/async/generate_allocation_exhaustive.dart';
import 'package:money_pilot/domain/usecases/async/generate_allocation_greedy.dart';
import 'package:money_pilot/domain/usecases/async/generate_allocation_prevalent.dart';
import 'package:money_pilot/domain/usecases/async/get_theme.dart';
import 'package:money_pilot/domain/usecases/async/set_theme.dart';
import 'package:money_pilot/domain/usecases/async/update_category.dart';
import 'package:money_pilot/domain/usecases/category/read_category.dart';
import 'package:money_pilot/domain/usecases/create_set_allocation.dart';
import 'package:money_pilot/domain/usecases/create_transaction.dart';
import 'package:money_pilot/domain/usecases/delete_category.dart';
import 'package:money_pilot/domain/usecases/delete_set_allocation.dart';
import 'package:money_pilot/domain/usecases/delete_transaction.dart';
import 'package:money_pilot/domain/usecases/filter_category_by_type.dart';
import 'package:money_pilot/domain/usecases/filter_transaction_by_category_type.dart';
import 'package:money_pilot/domain/usecases/read_category_by_key.dart';
import 'package:money_pilot/domain/usecases/read_set_allocations.dart';
import 'package:money_pilot/domain/usecases/read_transactions.dart';
import 'package:money_pilot/domain/usecases/sort_transaction.dart';
import 'package:money_pilot/presentation/bloc/category/cubit.dart';
import 'package:money_pilot/presentation/bloc/set_allocation/cubit.dart';
import 'package:money_pilot/presentation/bloc/theme/cubit.dart';
import 'package:money_pilot/presentation/bloc/transaction/cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeServiceLocator() async {
  // providers
  serviceLocator.registerLazySingleton(() => ProviderLocal());

  // repositories
  serviceLocator.registerLazySingleton<RepositoryCategory>(
      () => RepositoryCategoryImpl(providerLocal: serviceLocator()));
  serviceLocator.registerLazySingleton<RepositoryTransaction>(
      () => RepositoryTransactionImpl(providerLocal: serviceLocator()));
  serviceLocator.registerLazySingleton<RepositoryTheme>(
      () => RepositoryThemeImpl(providerLocal: serviceLocator()));
  serviceLocator.registerLazySingleton<RepositorySetAllocation>(
      () => RepositorySetAllocationImpl(providerLocal: serviceLocator()));

  // usecases
  // - category
  serviceLocator.registerLazySingleton(
      () => UseCaseAsyncCreateCategory(repositoryCategory: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UseCaseReadCategory(repositoryCategory: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UseCaseReadCategoryByKey(repositoryCategory: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UseCaseAsyncUpdateCategory(repositoryCategory: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UseCaseDeleteCategory(repositoryCategory: serviceLocator()));
  serviceLocator.registerLazySingleton(() => UseCaseFilterCategoryByType());

  // - allocation
  serviceLocator.registerLazySingleton(() => UseCaseGenerateAllocationGreedy());
  serviceLocator
      .registerLazySingleton(() => UseCaseGenerateAllocationExhaustive());
  serviceLocator
      .registerLazySingleton(() => UseCaseAsyncGenerateAllocationPrevalent());

  // - transaction
  serviceLocator.registerLazySingleton(
      () => UseCaseCreateTransaction(repositoryTransaction: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UseCaseReadTransactions(repositoryTransaction: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UseCaseDeleteTransaction(repositoryTransaction: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UseCaseFilterTransactionByCategoryType());
  serviceLocator.registerLazySingleton(() => UseCaseSortTransaction());

  // - theme
  serviceLocator.registerLazySingleton(
      () => UseCaseAsyncSetTheme(repositoryTheme: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UseCaseAsyncGetTheme(repositoryTheme: serviceLocator()));

  // - set allocation
  serviceLocator.registerLazySingleton(() =>
      UseCaseCreateSetAllocation(repositorySetAllocation: serviceLocator()));
  serviceLocator.registerLazySingleton(() =>
      UseCaseReadSetAllocations(repositorySetAllocation: serviceLocator()));
  serviceLocator.registerLazySingleton(() =>
      UseCaseDeleteSetAllocation(repositorySetAllocation: serviceLocator()));

  // cubit
  serviceLocator.registerLazySingleton(
    () => CategoryCubit(
      useCaseReadCategory: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => CubitTransaction(
      useCaseReadTransactions: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => CubitTheme(
      useCaseAsyncSetTheme: serviceLocator(),
      useCaseAsyncGetTheme: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
      () => CubitSetAllocation(useCaseReadSetAllocations: serviceLocator()));

  // initialize cubit
  serviceLocator<CategoryCubit>().initialize();
  serviceLocator<CubitTransaction>().initialize();
  serviceLocator<CubitSetAllocation>().initialize();
  await serviceLocator<CubitTheme>().initialize();
}
