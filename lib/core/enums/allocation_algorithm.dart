enum AllocationAlgorithm {
  greedy,
  exhaustive,
  prevalent,
}

extension XAllocationAlgorithm on AllocationAlgorithm {
  bool get isGreedy => this == AllocationAlgorithm.greedy;
  bool get isExhaustive => this == AllocationAlgorithm.exhaustive;
  bool get isPrevalent => this == AllocationAlgorithm.prevalent;
}
