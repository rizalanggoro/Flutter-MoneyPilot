import 'package:money_pilot/core/enums/allocation_algorithm.dart';
import 'package:money_pilot/domain/models/allocation.dart';

class RouteParamAllocationCreateCategory {
  final AllocationAlgorithm algorithm;
  final Allocation? allocation;
  RouteParamAllocationCreateCategory({
    required this.algorithm,
    this.allocation,
  });
}
