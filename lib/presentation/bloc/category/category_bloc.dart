import 'package:bloc/bloc.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/usecases/read_category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final UseCaseReadCategory _useCaseReadCategory;

  CategoryBloc({
    required UseCaseReadCategory useCaseReadCategory,
  })  : _useCaseReadCategory = useCaseReadCategory,
        super(const CategoryState()) {
    on<CategoryInitialEvent>((event, emit) async {
      emit(state.copyWith(
        status: StateStatus.loading,
      ));

      final readResult = await _useCaseReadCategory.call(NoParams());

      readResult.fold(
        (l) => null,
        (r) => emit(state.copyWith(
          status: StateStatus.success,
          categories: r,
        )),
      );
    });

    on<CategoryAddEvent>((event, emit) async {
      emit(state.copyWith(
        status: StateStatus.success,
        categories: List.of(state.categories)..add(event.category),
      ));
    });

    on<CategoryRemoveEvent>((event, emit) async {
      emit(state.copyWith(
        status: StateStatus.loading,
      ));

      var foundIndex = -1;
      for (final (index, category) in state.categories.indexed) {
        if (category.key == event.category.key) {
          foundIndex = index;
          break;
        }
      }

      if (foundIndex != -1) {
        emit(state.copyWith(
          status: StateStatus.success,
          categories: List.of(state.categories)..removeAt(foundIndex),
        ));
      } else {
        emit(state.copyWith(
          status: StateStatus.success,
        ));
      }
    });
  }
}
