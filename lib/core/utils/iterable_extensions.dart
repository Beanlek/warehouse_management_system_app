extension IterableExtension<T> on Iterable<T> {
  Iterable<R> mapNotNull<R>(R? Function(T) transform) sync* {
    for (var element in this) {
      var value = transform(element);
      if (value != null) {
        yield value;
      }
    }
  }

  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
