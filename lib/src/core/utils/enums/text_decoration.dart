import 'package:flutter/material.dart';

///This super enum is used to convert `TextDecoration` to `RTFTextDecorationEnum` and vice versa.
/// It is being used to allow for easy data serialization. since `TextDecoration` does not expose `toJson()` and `fromJson()` methods.
enum RTFTextDecorationEnum {
  none(TextDecoration.none, 'none'),
  underline(TextDecoration.underline, 'underline'),
  strikeThrough(TextDecoration.lineThrough, 'line-through'),
  ;

  final TextDecoration value;
  final String cssValue;

  const RTFTextDecorationEnum(this.value, this.cssValue);

  factory RTFTextDecorationEnum.fromDecoration(TextDecoration decoration) {
    return values.firstWhere((element) => element.value == decoration);
  }
}
