import 'package:get_it/get_it.dart';
import 'package:money_pilot/data/providers/local.dart';
import 'package:money_pilot/data/repositories/category_impl.dart';
import 'package:money_pilot/data/repositories/transaction_impl.dart';
import 'package:money_pilot/domain/repositories/category.dart';
import 'package:money_pilot/domain/repositories/transaction.dart';
import 'package:money_pilot/domain/usecases/create_category.dart';
import 'package:money_pilot/domain/usecases/create_transaction.dart';
import 'package:money_pilot/domain/usecases/delete_category.dart';
import 'package:money_pilot/domain/usecases/filter_category_by_type.dart';
import 'package:money_pilot/domain/usecases/generate_allocation_exhaustive.dart';
import 'package:money_pilot/domain/usecases/generate_allocation_greedy.dart';
import 'package:money_pilot/domain/usecases/read_category.dart';
import 'package:money_pilot/presentation/bloc/category/category_bloc.dart';
import 'package:money_pilot/presentation/bloc/transaction/transaction_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeServiceLocator() async {
  // providers
  serviceLocator.registerLazySingleton(() => ProviderLocal());

  // repositories
  serviceLocator.registerLazySingleton<RepositoryCategory>(
    () => RepositoryCategoryImpl(
      providerLocal: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<RepositoryTransaction>(
    () => RepositoryTransactionImpl(
      providerLocal: serviceLocator(),
    ),
  );

  // usecases
  // - category
  serviceLocator.registerLazySingleton(
    () => UseCaseCreateCategory(
      repositoryCategory: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => UseCaseReadCategory(
      repositoryCategory: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => UseCaseDeleteCategory(
      repositoryCategory: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => UseCaseFilterCategoryByType(),
  );

  // - allocation
  serviceLocator.registerLazySingleton(
    () => UseCaseGenerateAllocationGreedy(),
  );
  serviceLocator.registerLazySingleton(
    () => UseCaseGenerateAllocationExhaustive(),
  );

  // - transaction
  serviceLocator.registerLazySingleton(
    () => UseCaseCreateTransaction(
      repositoryTransaction: serviceLocator(),
    ),
  );

  // cubit & bloc
  serviceLocator.registerLazySingleton(
    () => CategoryBloc(
      useCaseReadCategory: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => TransactionBloc(),
  );

  // initialize bloc
  serviceLocator<CategoryBloc>().add(CategoryInitialEvent());
}
