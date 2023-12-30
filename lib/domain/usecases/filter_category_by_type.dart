import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/category.dart';

class ParamsFilterCategoryByType {
  final List<Category> categories;
  final CategoryType type;

  ParamsFilterCategoryByType({
    required this.categories,
    required this.type,
  });
}

class UseCaseFilterCategoryByType
    implements UseCase<ParamsFilterCategoryByType, List<Category>> {
  @override
  Either<Failure, List<Category>> call(ParamsFilterCategoryByType params) {
    List<Category> result = [];

    // linear search
    for (final category in params.categories) {
      if (category.type == params.type) {
        result.add(category);
      }
    }

    return Right(result);
  }
}
