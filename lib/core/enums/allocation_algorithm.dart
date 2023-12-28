enum AllocationAlgorithm { greedy, exhaustive }

extension XAllocationAlgorithm on AllocationAlgorithm {
  bool get isGreedy => this == AllocationAlgorithm.greedy;
  bool get isExhaustive => this == AllocationAlgorithm.exhaustive;
}
