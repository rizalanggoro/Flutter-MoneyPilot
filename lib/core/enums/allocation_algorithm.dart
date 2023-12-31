enum AllocationAlgorithm {
  greedy,
  exhaustive,
  fairness,
}

extension XAllocationAlgorithm on AllocationAlgorithm {
  bool get isGreedy => this == AllocationAlgorithm.greedy;
  bool get isExhaustive => this == AllocationAlgorithm.exhaustive;
  bool get isFairness => this == AllocationAlgorithm.fairness;
}
