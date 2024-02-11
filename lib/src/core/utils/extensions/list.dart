/// `RTFListExtension` is a extension for `List` class
extension RTFListExtension<E> on List<E> {
  /// `firstOrNull` returns the first element of the list or `null` if the list is empty.
  E? get firstOrNull {
    try {
      return first;
    } catch (e) {
      return null;
    }
  }

  /// `lastOrNull` returns the last element of the list or `null` if the list is empty.
  E? get lastOrNull {
    try {
      return last;
    } catch (e) {
      return null;
    }
  }

  /// `elementAtOrNull` returns the element at the given index or `null` if the index is out of bounds.
  E? elementAtOrNull(int index) {
    try {
      return this[index];
    } catch (e) {
      return null;
    }
  }

  /// `addItemBetweenList` adds an item at the given index.
  void addItemBetweenList(
    int index, {
    required E item,
  }) {
    if (index > length) throw Exception('Index out of bounds');
    if (index == length) return add(item);

    final List<E> completeList = [
      ...sublist(0, index),
      item,
      ...sublist(index, length),
    ];

    clear();
    addAll(completeList);
  }
}
