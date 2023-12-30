import 'package:money_pilot/core/enums/allocation_algorithm.dart';
import 'package:money_pilot/domain/models/allocation_category.dart';

class RouteParamAllocationCreateCategory {
  final AllocationAlgorithm algorithm;
  final AllocationCategory? allocation;
  RouteParamAllocationCreateCategory({
    required this.algorithm,
    this.allocation,
  });
}
