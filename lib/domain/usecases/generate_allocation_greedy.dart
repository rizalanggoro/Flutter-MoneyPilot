import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/allocation_category.dart';

class ParamGenerateAllocationGreedy {
  final int maxAmount;
  final List<AllocationCategory> allocations;

  ParamGenerateAllocationGreedy({
    required this.maxAmount,
    required this.allocations,
  });
}

class UseCaseGenerateAllocationGreedy
    implements
        UseCase<ParamGenerateAllocationGreedy, List<AllocationCategory>> {
  @override
  Future<Either<Failure, List<AllocationCategory>>> call(
    ParamGenerateAllocationGreedy params,
  ) async {
    if (params.maxAmount <= 0) {
      return Left(Failure(
        message: 'Batas maksimal dana tidak boleh lebih '
            'kecil sama dengan Rp 0,00!',
      ));
    }

    if (params.allocations.isEmpty) {
      return Left(Failure(
        message: 'Tidak ada kategori yang dialokasikan!',
      ));
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
    for (final allocation in allocations) {
      if (totalAmount + allocation.amount <= params.maxAmount) {
        result.add(allocation);
        totalAmount += allocation.amount;
      } else {
        result.add(allocation.copyWith(
          amount: params.maxAmount - totalAmount,
        ));

        // karena sudah penuh, maka lakukan break
        break;
      }
    }

    return Right(result);
  }
}
