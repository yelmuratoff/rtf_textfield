import 'package:rtf_textfield/src/core/models/text_delta.dart';
import 'package:rtf_textfield/src/core/models/text_metadata.dart';
import 'package:rtf_textfield/src/core/utils/extensions/string.dart';
import 'package:rtf_textfield/src/core/utils/extensions/text_deltas.dart';

/// `TextDeltasUtils` is a utility class that provides helper methods for `TextDeltas`
abstract class RTFTextDeltasUtils {
  /// Converts a string to `TextDeltas`
  static TextDeltas deltasFromString(
    String string, [
    RTFTextMetadata? metadata,
  ]) {
    final TextDeltas deltas = [];
    final List<String> chars = string.chars;

    for (final String char in chars) {
      deltas.add(RTFTextDelta(char: char, metadata: metadata));
    }
    return deltas;
  }

  /// Converts a list of `Map` to `TextDeltas`
  static TextDeltas deltasFromList(List<Map> list) {
    final TextDeltas deltas = [];
    for (dynamic map in list) {
      deltas.add(RTFTextDelta.fromMap((map as Map).cast<String, dynamic>()));
    }
    return deltas;
  }
}
