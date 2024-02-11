import 'package:rtf_textfield/src/core/models/text_delta.dart';

/// Sugar for working with list of [TextDelta]s.
typedef TextDeltas = List<RTFTextDelta>;

/// `RTFTextDeltasExtension` is an extension for `TextDeltas` class.
extension RTFTextDeltasExtension on TextDeltas {
  /// Getter `text` return the string for given. Getter that retrieves a concatenated string from the elements of the collection.
  String get text {
    // If the collection is empty, immediately return an empty string.
    if (isEmpty) return '';

    // Initialize a StringBuffer with the character of the first element.
    final StringBuffer stringBuffer = StringBuffer(first.char);

    // Iterate through the remaining elements starting from the second item.
    for (int i = 1; i < length; i++) {
      // Append the character of each element to the StringBuffer.
      stringBuffer.write(this[i].char);
    }

    // Convert the contents of the StringBuffer into a String.
    return stringBuffer.toString();
  }

  /// Creates a value copy of the list
  TextDeltas get copy => List.from(this);
}
