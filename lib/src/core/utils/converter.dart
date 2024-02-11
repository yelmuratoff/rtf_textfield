import 'package:flutter/material.dart' as material;
import 'package:rtf_textfield/src/view/input_decoration/rtf_input_decorator.dart';

/// This is the base class for all RTF converters
abstract class RTFConverter {
  /// Converts a `Map` to `Color`
  static material.Color colorFromMap(dynamic map) {
    return material.Color(int.parse(map['color'].toString()));
  }

  /// Convert material's `FloatingLabelBehavior` to RTF's `FloatingLabelBehavior`
  static FloatingLabelBehavior convertMaterial2FloatingLabelBehavior(
    material.FloatingLabelBehavior behavior,
  ) {
    switch (behavior) {
      case material.FloatingLabelBehavior.auto:
        return FloatingLabelBehavior.auto;
      case material.FloatingLabelBehavior.always:
        return FloatingLabelBehavior.always;
      case material.FloatingLabelBehavior.never:
        return FloatingLabelBehavior.never;
    }
  }

  /// Convert material's `InputDecorationTheme` to RTF's `InputDecorationTheme`
  static InputDecorationTheme convertMaterial2InputDecorationTheme(
    material.InputDecorationTheme theme,
  ) {
    return InputDecorationTheme(
      labelStyle: theme.labelStyle,
      helperStyle: theme.helperStyle,
      helperMaxLines: theme.helperMaxLines,
      hintStyle: theme.hintStyle,
      errorStyle: theme.errorStyle,
      errorMaxLines: theme.errorMaxLines,
      floatingLabelBehavior: convertMaterial2FloatingLabelBehavior(
        theme.floatingLabelBehavior,
      ),
      isDense: theme.isDense,
      contentPadding: theme.contentPadding,
      isCollapsed: theme.isCollapsed,
      prefixStyle: theme.prefixStyle,
      suffixStyle: theme.suffixStyle,
      counterStyle: theme.counterStyle,
      filled: theme.filled,
      fillColor: theme.fillColor,
      focusColor: theme.focusColor,
      hoverColor: theme.hoverColor,
      errorBorder: theme.errorBorder,
      focusedBorder: theme.focusedBorder,
      focusedErrorBorder: theme.focusedErrorBorder,
      disabledBorder: theme.disabledBorder,
      enabledBorder: theme.enabledBorder,
      border: theme.border,
      alignLabelWithHint: theme.alignLabelWithHint,
    );
  }
}
