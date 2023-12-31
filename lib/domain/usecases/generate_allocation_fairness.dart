import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/core/usecase/usecase.dart';
import 'package:money_pilot/domain/models/allocation_category.dart';

class ParamGenerateAllocationFairness {
  final int maxAmount;
  final List<AllocationCategory> allocationCategories;
  ParamGenerateAllocationFairness({
    required this.maxAmount,
    required this.allocationCategories,
  });
}

class UseCaseGenerateAllocationFairness
    implements
        UseCase<ParamGenerateAllocationFairness, List<AllocationCategory>> {
  final _factor = .1;

  @override
  Future<Either<Failure, List<AllocationCategory>>> call(
    ParamGenerateAllocationFairness params,
  ) async {
    // validasi
    if (params.maxAmount <= 0) {
      return Left(Failure(
        message: 'Batas maksimal dana tidak boleh lebih '
            'kecil sama dengan Rp 0,00!',
      ));
    }

    if (params.allocationCategories.isEmpty) {
      return Left(Failure(
        message: 'Tidak ada kategori yang dialokasikan!',
      ));
    }

    List<AllocationCategory> allocations = [];

    // menghitung densitas masing-masing kategori
    for (final (index, allocation) in params.allocationCategories.indexed) {
      final density =
          (params.allocationCategories.length - index) / allocation.amount;
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

    var totalAmount = 0.0;
    var index = 0;
    var resultFactors = List.generate(allocations.length, (index) => 0.0);
    while (totalAmount < params.maxAmount) {
      final allocation = allocations[index];

      if (resultFactors[index] == 0) {
        // alokasi pertama
        final expectedAmount = allocation.amount * _factor;
        if (totalAmount + expectedAmount <= params.maxAmount) {
          resultFactors[index] = _factor;
          totalAmount += expectedAmount;
        } else {
          var dynamicFactor =
              (params.maxAmount - totalAmount) / allocation.amount;
          resultFactors[index] = dynamicFactor;
          totalAmount += dynamicFactor * allocation.amount;
        }
      } else {
        // alokasi kedua dan seterusnya
        final expectedAmount = _factor * allocation.amount;
        if (resultFactors[index] < 1 &&
            totalAmount + expectedAmount <= params.maxAmount) {
          resultFactors[index] += _factor;
          totalAmount += expectedAmount;
        } else {
          var dynamicFactor =
              (params.maxAmount - totalAmount) / allocation.amount;
          if (dynamicFactor > 1) {
            dynamicFactor = 1;
          }
          resultFactors[index] += dynamicFactor;
          totalAmount += dynamicFactor * allocation.amount;
        }
      }

      index = (index < allocations.length - 1) ? (index + 1) : 0;
    }

    List<AllocationCategory> result = [];
    for (var a = 0; a < allocations.length; a++) {
      result.add(allocations[a].copyWith(
        amount: (allocations[a].amount * resultFactors[a]).floor(),
      ));
    }
    return Right(result);
  }
}
