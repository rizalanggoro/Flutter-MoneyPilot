import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/allocation.dart';

class ParamsGenerateAllocationGreedy {
  final int totalAmount;
  final List<Allocation> allocations;

  ParamsGenerateAllocationGreedy({
    required this.totalAmount,
    required this.allocations,
  });
}

class UseCaseGenerateAllocationGreedy
    implements AsyncUseCase<ParamsGenerateAllocationGreedy, List<Allocation>> {
  @override
  Future<Either<Failure, List<Allocation>>> call(
    ParamsGenerateAllocationGreedy params,
  ) async {
    List<Allocation> allocations = [];

    // calculate density
    for (final (index, allocation) in params.allocations.indexed) {
      final density = (params.allocations.length - index) / allocation.amount;
      allocations.add(
        allocation.copyWith(
          density: density,
        ),
      );
    }

    // sort: bubble sort
    for (var a = 0; a < allocations.length - 1; a++) {
      for (var b = 0; b < (allocations.length - 1 - a); b++) {
        if ((allocations[b].density ?? 0) < (allocations[b + 1].density ?? 0)) {
          final allocationTemp = allocations[b];
          allocations[b] = allocations[b + 1];
          allocations[b + 1] = allocationTemp;
        }
      }
    }

    // greedy
    final List<Allocation> result = [];
    int totalAmount = 0;
    var isStillFits = true;
    for (final allocation in allocations) {
      if (isStillFits) {
        if (totalAmount + allocation.amount <= params.totalAmount) {
          result.add(allocation);
          totalAmount += allocation.amount;
        } else {
          result.add(allocation.copyWith(
            amount: params.totalAmount - totalAmount,
          ));
          isStillFits = false;
        }
      } else {
        result.add(allocation.copyWith(
          amount: 0,
        ));
      }
    }

    return Right(result);
  }
}
