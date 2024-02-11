import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rtf_textfield/src/core/models/text_delta.dart';
import 'package:rtf_textfield/src/core/models/text_metadata.dart';
import 'package:rtf_textfield/src/core/utils/enums/text_decoration.dart';
import 'package:rtf_textfield/src/core/utils/enums/text_metadata.dart';
import 'package:rtf_textfield/src/core/utils/extensions/list.dart';
import 'package:rtf_textfield/src/core/utils/extensions/string.dart';
import 'package:rtf_textfield/src/core/utils/extensions/text_deltas.dart';
import 'package:rtf_textfield/src/core/utils/text_deltas.dart';

part 'base_rtf_controller.dart';

/// This is the main controller for the text editor
class RTFTextFieldController extends _RichTextEditorController {
  ///This holds all the text changes per character and it's corresponding style/metadata
  @override
  // ignore: overridden_fields
  final TextDeltas deltas;

  static const RTFTextMetadata defaultMetadata = RTFTextMetadata(
    alignment: TextAlign.start,
    decoration: RTFTextDecorationEnum.none,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontFeatures: null,
  );

  /// Constructs an instance of [RTFTextFieldController] with the provided [text] and [deltas]
  ///
  /// if [text] is not provided, it will be generated from the [deltas].
  /// if [delta] is not provided, it will be generated from the [text] and [metadata].
  /// [metadata] is optional and if not provided, it will be set to [defaultMetadata]
  RTFTextFieldController({
    String? text,
    TextDeltas? deltas,
    RTFTextMetadata? metadata,
  })  : deltas = deltas ??
            (text == null
                ? []
                : RTFTextDeltasUtils.deltasFromString(
                    text,
                    metadata ?? defaultMetadata,
                  )),
        super(
          text: text ?? deltas?.text,
          metaData: metadata,
        ) {
    addListener(_internalControllerListener);
  }

  @override
  RTFTextFieldController copy() {
    return RTFTextFieldController(
      text: text,
      deltas: deltas.copy,
    )
      ..value = value
      ..metadata = metadata;
  }

  /// Data serializer method for this class
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'deltas': deltas.map((RTFTextDelta delta) => delta.toMap()).toList(),
      'metadata': metadata?.toMap(),
      'value': value.toJSON(),
    };
  }

  /// Data deserializer method for this class
  ///
  /// This is used to create a new instance of this class from a map
  factory RTFTextFieldController.fromMap(Map<String, dynamic> map) {
    return RTFTextFieldController(
      text: map['text'] as String,
      deltas: RTFTextDeltasUtils.deltasFromList(
        (map['deltas'] as List).cast<Map>(),
      ),
    )
      ..value = TextEditingValue.fromJSON(
        (map['value'] as Map).cast<String, dynamic>(),
      )
      ..metadata = map['metadata'] == null
          ? null
          : RTFTextMetadata.fromMap(
              (map['metadata'] as Map).cast<String, dynamic>(),
            );
  }
}
