/// `RTFIterableExtension` is a extension for `Iterable` class.
extension RTFIterableExtension<E> on Iterable<E> {
  /// `containsWhere` returns `true` if the iterable contains an element
  bool containsWhere(bool Function(E value) test) {
    for (E element in this) {
      bool satisfied = test(element);
      if (satisfied) {
        return true;
      }
    }
    return false;
  }
}
