import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rtf_textfield/src/core/utils/converter.dart';
import 'package:rtf_textfield/src/core/utils/enums/text_decoration.dart';
import 'package:rtf_textfield/src/core/utils/enums/text_metadata.dart';
import 'package:rtf_textfield/src/core/utils/extensions/color.dart';

/// `RTFTextMetadata` is a class that holds the style change for each character.
class RTFTextMetadata {
  final Color color;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double fontSize;
  final RTFTextDecorationEnum decoration;
  final List<FontFeature>? fontFeatures;
  final TextAlign alignment;

  const RTFTextMetadata({
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.fontStyle = FontStyle.normal,
    this.fontSize = 14,
    this.alignment = TextAlign.start,
    this.decoration = RTFTextDecorationEnum.none,
    this.fontFeatures,
  });

  RTFTextMetadata.fromTextStyle(
    TextStyle style, {
    this.alignment = TextAlign.start,
  })  : color = style.color ?? Colors.black,
        fontWeight = style.fontWeight ?? FontWeight.w400,
        fontStyle = style.fontStyle ?? FontStyle.normal,
        fontSize = style.fontSize ?? 14,
        decoration = style.decoration == null
            ? RTFTextDecorationEnum.none
            : RTFTextDecorationEnum.fromDecoration(style.decoration!),
        fontFeatures = style.fontFeatures;

  RTFTextMetadata copyWith({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize,
    RTFTextDecorationEnum? decoration,
    List<FontFeature>? fontFeatures,
    TextAlign? alignment,
  }) {
    return RTFTextMetadata(
      color: color ?? this.color,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      fontSize: fontSize ?? this.fontSize,
      decoration: decoration ?? this.decoration,
      fontFeatures: fontFeatures ?? this.fontFeatures,
      alignment: alignment ?? this.alignment,
    );
  }

  /// This method is used to combine two `RTFTextMetadata` objects relative to the specified `TextMetadataChange`
  RTFTextMetadata combineWhatChanged(
    RTFTextMetadataChangeEnum change,
    RTFTextMetadata other,
  ) {
    return switch (change) {
      RTFTextMetadataChangeEnum.all => other,
      RTFTextMetadataChangeEnum.color => copyWith(color: other.color),
      RTFTextMetadataChangeEnum.fontWeight =>
        copyWith(fontWeight: other.fontWeight),
      RTFTextMetadataChangeEnum.fontStyle =>
        copyWith(fontStyle: other.fontStyle),
      RTFTextMetadataChangeEnum.fontSize => copyWith(fontSize: other.fontSize),
      RTFTextMetadataChangeEnum.alignment =>
        copyWith(alignment: other.alignment),
      RTFTextMetadataChangeEnum.fontDecoration =>
        copyWith(decoration: other.decoration),
      RTFTextMetadataChangeEnum.fontFeatures =>
        copyWith(fontFeatures: other.fontFeatures),
    };
  }

  TextStyle get style => TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: decoration.value,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontFeatures: fontFeatures,
      );

  TextStyle get styleWithoutFontFeatures => TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: decoration.value,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      );

  /// `combineWhereNotEqual` is used to combine two `RTFTextMetadata` objects
  factory RTFTextMetadata.combineWhereNotEqual(
    final RTFTextMetadata firstMetadata,
    final RTFTextMetadata secondMetaData, {
    bool favourFirst = true,
  }) {
    return RTFTextMetadata(
      color: favourFirst ? firstMetadata.color : secondMetaData.color,
      fontWeight:
          favourFirst ? firstMetadata.fontWeight : secondMetaData.fontWeight,
      fontStyle:
          favourFirst ? firstMetadata.fontStyle : secondMetaData.fontStyle,
      fontSize: favourFirst ? firstMetadata.fontSize : secondMetaData.fontSize,
      decoration:
          favourFirst ? firstMetadata.decoration : secondMetaData.decoration,
      fontFeatures: favourFirst
          ? firstMetadata.fontFeatures
          : secondMetaData.fontFeatures,
      alignment:
          favourFirst ? firstMetadata.alignment : secondMetaData.alignment,
    );
  }

  RTFTextMetadata combineWith(
    RTFTextMetadata other, {
    bool favourOther = true,
  }) {
    return RTFTextMetadata(
      color: color == other.color
          ? color
          : favourOther
              ? other.color
              : color,
      fontWeight: fontWeight == other.fontWeight
          ? fontWeight
          : favourOther
              ? other.fontWeight
              : fontWeight,
      fontStyle: fontStyle == other.fontStyle
          ? fontStyle
          : favourOther
              ? other.fontStyle
              : fontStyle,
      fontSize: fontSize == other.fontSize
          ? fontSize
          : favourOther
              ? other.fontSize
              : fontSize,
      decoration: decoration == other.decoration
          ? decoration
          : favourOther
              ? other.decoration
              : decoration,
      fontFeatures: fontFeatures == other.fontFeatures
          ? fontFeatures
          : favourOther
              ? other.fontFeatures ?? fontFeatures
              : fontFeatures ?? other.fontFeatures,
      alignment: alignment == other.alignment
          ? alignment
          : favourOther
              ? other.alignment
              : alignment,
    );
  }

  factory RTFTextMetadata.fromMap(Map<String, dynamic> map) {
    return RTFTextMetadata(
      color: RTFConverter.colorFromMap(map),
      fontWeight: FontWeight.values[(map['fontWeight'])],
      fontStyle: FontStyle.values[(map['fontStyle'])],
      fontSize: map['fontSize'] as double,
      fontFeatures: (map['fontFeatures'] as List?)
          ?.cast<Map<String, dynamic>>()
          .map((e) => _fontFeatureFromMap(e))
          .toList(),
      alignment: TextAlign.values[(map['alignment'])],
      decoration: RTFTextDecorationEnum.values[(map['decoration'])],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color.toSerializerString,
      'fontWeight': fontWeight.index,
      'fontStyle': fontStyle.index,
      'fontSize': fontSize,
      'fontFeatures': fontFeatures?.map((e) => _fontFeatureToMap(e)).toList(),
      'alignment': alignment.index,
      'decoration': decoration.index,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RTFTextMetadata &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          fontWeight == other.fontWeight &&
          fontStyle == other.fontStyle &&
          fontSize == other.fontSize &&
          decoration == other.decoration &&
          fontFeatures == other.fontFeatures &&
          alignment == other.alignment;

  @override
  int get hashCode =>
      color.hashCode ^
      fontWeight.hashCode ^
      fontStyle.hashCode ^
      fontSize.hashCode ^
      decoration.hashCode ^
      fontFeatures.hashCode ^
      alignment.hashCode;

  @override
  String toString() {
    return '''
RTFTextMetadata{
      color: $color,
      fontWeight: $fontWeight,
      fontStyle: $fontStyle,
      fontSize: $fontSize,
      decoration: $decoration,
      fontFeatures: $fontFeatures,
      alignment: $alignment
    }''';
  }
}

/// `_fontFeatureFromMap` is a private function that converts a map to a `FontFeature` object
FontFeature _fontFeatureFromMap(Map map) {
  return FontFeature(
    map['feature'],
    map['value'],
  );
}

/// `_fontFeatureToMap` is a private function that converts a `FontFeature` object to a map
Map<String, dynamic> _fontFeatureToMap(FontFeature feature) {
  return {
    'feature': feature.feature,
    'value': feature.value,
  };
}
