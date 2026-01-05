class PaginationState<T> {
  final List<T> items;
  final bool isLoading;
  final bool hasNext;
  final String? error;

  PaginationState({required this.items, required this.isLoading, required this.hasNext, this.error});

  factory PaginationState.initial() => PaginationState(items: [], isLoading: false, hasNext: true);

  PaginationState<T> copyWith({List<T>? items, bool? isLoading, bool? hasNext, String? error}) {
    return PaginationState(items: items ?? this.items, isLoading: isLoading ?? this.isLoading, hasNext: hasNext ?? this.hasNext, error: error);
  }
}
