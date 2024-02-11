import 'package:flutter/material.dart';

/// `RTFColorExtension` is an extension for `Color`
extension RTFColorExtension on Color {
  /// `toSerializerString` returns the string representation of the color.
  String get toSerializerString => value.toString();
}
