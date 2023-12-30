import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/allocation_category.dart';

class ParamsGenerateAllocationExhaustive {
  final int maxAmount;
  final List<AllocationCategory> allocations;
  ParamsGenerateAllocationExhaustive({
    required this.maxAmount,
    required this.allocations,
  });
}

class UseCaseGenerateAllocationExhaustive
    implements
        UseCase<ParamsGenerateAllocationExhaustive, List<AllocationCategory>> {
  @override
  Future<Either<Failure, List<AllocationCategory>>> call(
    ParamsGenerateAllocationExhaustive params,
  ) async {
    // validasi
    if (params.maxAmount <= 0) {
      return Left(
        Failure(
          message:
              'Batas maksimal dana tidak boleh lebih kecil sama dengan Rp 0,00!',
        ),
      );
    }

    final List<_ExhaustiveItem> listExhaustive = [];
    final List<AllocationCategory> allocations = [];

    // menghitung densitas masing-masing alokasi kategori
    for (final (index, allocation) in params.allocations.indexed) {
      final density = (params.allocations.length - index) / allocation.amount;
      allocations.add(
        allocation.copyWith(
          density: density,
        ),
      );
    }

    // men-generate semua kombinasi
    _generateAllCombinations(
      allocations: allocations,
      currentAllocationCombinations: [],
      listExhaustive: listExhaustive,
    );

    // eliminasi yang melebihi alokasi maksimal
    final List<_ExhaustiveItem> listEliminatedExhaustive = [];
    for (final item in listExhaustive) {
      if (item.totalAmount <= params.maxAmount) {
        listEliminatedExhaustive.add(item);
      }
    }

    if (listEliminatedExhaustive.isEmpty) {
      return Left(Failure(message: 'Gagal mengalokasikan dana!'));
    }

    // cari kombinasi dengan densitas terbesar
    _ExhaustiveItem currentExhaustiveItem = listEliminatedExhaustive[0];
    for (var a = 0; a < listEliminatedExhaustive.length - 1; a++) {
      if (listEliminatedExhaustive[a + 1].totalDensity >
          currentExhaustiveItem.totalDensity) {
        currentExhaustiveItem = listEliminatedExhaustive[a + 1];
      }
    }

    return Right(currentExhaustiveItem.combinations);
  }

  _generateAllCombinations({
    required List<AllocationCategory> allocations,
    required List<AllocationCategory> currentAllocationCombinations,
    required List<_ExhaustiveItem> listExhaustive,
  }) {
    // hitung total densitas dan total amount
    if (currentAllocationCombinations.isNotEmpty) {
      double totalDensity = 0;
      int totalAmount = 0;
      for (final allocation in currentAllocationCombinations) {
        totalDensity += allocation.density ?? 0;
        totalAmount += allocation.amount;
      }
      listExhaustive.add(
        _ExhaustiveItem(
          totalDensity: totalDensity,
          totalAmount: totalAmount,
          combinations: currentAllocationCombinations,
        ),
      );
    }

    for (var a = 0; a < allocations.length; a++) {
      List<AllocationCategory> newAllocationCombinations =
          List.of(currentAllocationCombinations);
      newAllocationCombinations.add(allocations[a]);
      _generateAllCombinations(
        allocations: allocations.sublist(a + 1),
        currentAllocationCombinations: newAllocationCombinations,
        listExhaustive: listExhaustive,
      );
    }
  }
}

class _ExhaustiveItem {
  final double totalDensity;
  final int totalAmount;
  final List<AllocationCategory> combinations;
  _ExhaustiveItem({
    required this.totalDensity,
    required this.totalAmount,
    required this.combinations,
  });
}
