class MoriCachedState<T> {
  const MoriCachedState({
    required this.isCache,
    required this.value,
  });
  final T value;
  final bool isCache;
}
