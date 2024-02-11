import 'package:rtf_textfield/src/core/models/text_metadata.dart';

/// `RTFTextDelta` is a class that holds the character and its metadata.
class RTFTextDelta {
  final String char;
  final RTFTextMetadata? metadata;

  const RTFTextDelta({
    required this.char,
    this.metadata,
  });

  RTFTextDelta copyWith({
    String? char,
    RTFTextMetadata? metadata,
  }) {
    return RTFTextDelta(
      char: char ?? this.char,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return '''
RTFTextDelta(
  char: $char
)''';
  }

  Map<String, dynamic> toMap() {
    return {
      'char': char,
      'metadata': metadata?.toMap(),
    };
  }

  factory RTFTextDelta.fromMap(Map<String, dynamic> map) {
    return RTFTextDelta(
      char: map['char'] as String,
      metadata: map['metadata'] == null
          ? null
          : RTFTextMetadata.fromMap(
              (map['metadata'] as Map).cast<String, dynamic>(),
            ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RTFTextDelta &&
          runtimeType == other.runtimeType &&
          char == other.char &&
          metadata == other.metadata;

  @override
  int get hashCode => char.hashCode ^ metadata.hashCode;
}
