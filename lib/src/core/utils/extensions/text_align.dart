import 'package:flutter/material.dart';

/// This extension is used to convert `TextAlign` to `Alignment` and vice versa.
extension RTFTextAlignExtension on TextAlign {
  /// Converts `TextAlign` to `Alignment`
  Alignment get toAlignment {
    return switch (this) {
      TextAlign.start || TextAlign.left => Alignment.centerLeft,
      TextAlign.end || TextAlign.right => Alignment.centerRight,
      TextAlign.center => Alignment.center,
      TextAlign.justify => Alignment.center,
    };
  }
}
