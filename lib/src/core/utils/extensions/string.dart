/// `RTFNullableStringExtension` is an extension for `String?` class.
extension RTFNullableStringExtension on String? {
  /// Returns `true` if the string is `null` or empty.
  bool get isNullOrEmpty => this?.isEmpty ?? true;
}

/// `RTFStringExtension` is an extension for `String` class.
extension RTFStringExtension on String {
  /// Removes all occurrences of the given [pattern] in the string.
  String removeAll(String pattern) {
    return replaceAll(pattern, '');
  }

  /// Returns a list of characters in the string.
  List<String> get chars => split('');
}
