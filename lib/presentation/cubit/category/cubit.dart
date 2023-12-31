import 'package:bloc/bloc.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/usecases/category/read_category.dart';

part 'state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final UseCaseReadCategory _useCaseReadCategory;

  CategoryCubit({
    required UseCaseReadCategory useCaseReadCategory,
  })  : _useCaseReadCategory = useCaseReadCategory,
        super(const CategoryState());

  void initialize() async {
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
  }

  void add({
    required Category category,
  }) {
    emit(state.copyWith(
      status: StateStatus.success,
      categories: List.of(state.categories)..add(category),
    ));
  }

  void update({
    required Category newCategory,
  }) {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));

    // linear search untuk mencari kategori
    // berdasarkan key
    var foundIndex = -1;
    for (final (index, category) in state.categories.indexed) {
      if (category.key == newCategory.key) {
        foundIndex = index;
        break;
      }
    }

    if (foundIndex != -1) {
      emit(state.copyWith(
        status: StateStatus.success,
        categories: List.of(state.categories)
          ..removeAt(foundIndex)
          ..insert(
            foundIndex,
            newCategory,
          ),
      ));
    } else {
      emit(state.copyWith(
        status: StateStatus.success,
      ));
    }
  }

  void remove({
    required int key,
  }) {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));

    // linear search untuk mencari kategori
    // berdasarkan key
    var foundIndex = -1;
    for (final (index, category) in state.categories.indexed) {
      if (category.key == key) {
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
  }
}
