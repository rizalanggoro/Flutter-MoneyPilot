import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/allocation_category.dart';

class ParamsGenerateAllocationGreedy {
  final int maxAmount;
  final List<AllocationCategory> allocations;

  ParamsGenerateAllocationGreedy({
    required this.maxAmount,
    required this.allocations,
  });
}

class UseCaseGenerateAllocationGreedy
    implements
        UseCase<ParamsGenerateAllocationGreedy, List<AllocationCategory>> {
  @override
  Future<Either<Failure, List<AllocationCategory>>> call(
    ParamsGenerateAllocationGreedy params,
  ) async {
    if (params.maxAmount <= 0) {
      return Left(
        Failure(
          message: 'Batas maksimal dana tidak boleh lebih '
              'kecil sama dengan Rp 0,00!',
        ),
      );
    }

    List<AllocationCategory> allocations = [];

    // menghitung densitas masing-masing kategori
    for (final (index, allocation) in params.allocations.indexed) {
      final density = (params.allocations.length - index) / allocation.amount;
      allocations.add(
        allocation.copyWith(
          density: density,
        ),
      );
    }

    // mengurutkan alokasi berdasarkan densitas terbesar
    // menggunakan algoritma bubble sort
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
    final List<AllocationCategory> result = [];
    int totalAmount = 0;
    var isStillFits = true;
    for (final allocation in allocations) {
      if (isStillFits) {
        if (totalAmount + allocation.amount <= params.maxAmount) {
          result.add(allocation);
          totalAmount += allocation.amount;
        } else {
          result.add(allocation.copyWith(
            amount: params.maxAmount - totalAmount,
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
