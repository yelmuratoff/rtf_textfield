part of 'rtf_text_field_controller.dart';

class _RichTextEditorController extends TextEditingController {
  ///This holds all the text changes per character and it's corresponding style/metadata
  final TextDeltas deltas;

  /// This holds the state of the text styles.
  /// on every selection change (collapsed or not) it's value defaults to that
  /// of the [TextDelta] before it in the [deltas] list or the [defaultMetadata] if it's the first
  RTFTextMetadata? _metadata;

  RTFTextMetadata? get metadata => _metadata;

  /// This is holds the state of the metadata change temporarily.
  ///
  /// it is reset when it's getter is called
  bool _metadataToggled = false;

  bool get metadataToggled {
    if (_metadataToggled) {
      final bool value = _metadataToggled;
      _metadataToggled = false;
      return value;
    }
    return _metadataToggled;
  }

  set metadataToggled(bool value) {
    _metadataToggled = value;
  }

  set metadata(RTFTextMetadata? value) {
    _metadata = value;
    notifyListeners();
  }

  /// returns a copy of this controller
  ///
  /// why? because all flutter [Listenable] objects are stored in memory and passed by reference
  _RichTextEditorController copy() {
    return _RichTextEditorController(
      text: text,
      deltas: deltas.copy,
    )
      ..value = value
      ..metadata = metadata;
  }

  /// returns a copy of this controller with the given parameters
  _RichTextEditorController copyWith({
    TextDeltas? deltas,
    TextEditingValue? value,
    RTFTextMetadata? metadata,
  }) {
    return _RichTextEditorController(
      text: text,
      deltas: deltas?.copy ?? this.deltas.copy,
    )
      ..value = value ?? this.value
      ..metadata = metadata ?? this.metadata;
  }

  _RichTextEditorController({
    super.text,
    TextDeltas? deltas,
    RTFTextMetadata? metaData,
  })  : _metadata = metaData ?? RTFTextFieldController.defaultMetadata,
        deltas = deltas ??
            (text == null ? [] : RTFTextDeltasUtils.deltasFromString(text)) {
    addListener(_internalControllerListener);
  }

  void _internalControllerListener() {
    TextDeltas newDeltas = compareNewStringAndOldTextDeltasForChanges(
      text,
      deltas.copy,
    );

    if (isListMode && newDeltas.length != deltas.length) {
      newDeltas = modifyDeltasForBulletListChange(
        newDeltas,
        deltas.copy,
      );
    }

    setDeltas(newDeltas);
  }

  void setDeltas(TextDeltas newDeltas) {
    deltas.clear();
    deltas.addAll(newDeltas);
    if (selection.isCollapsed) resetMetadataOnSelectionCollapsed();
  }

  void resetMetadataOnSelectionCollapsed() {
    if (!selection.isCollapsed) return;
    if (selection.end == text.length || textBeforeSelection().isNullOrEmpty) {
      return;
    }
    if (_metadataToggled) return;

    final RTFTextMetadata newMetadata = (deltas.isNotEmpty
            ? deltas[text.indexOf(selection.textBefore(text).chars.last)]
                .metadata
            : metadata) ??
        metadata ??
        RTFTextFieldController.defaultMetadata;

    _metadata = _metadata?.combineWith(
          newMetadata,
          favourOther: true,
        ) ??
        newMetadata;
  }

  String? textBeforeSelection() {
    try {
      return selection.textBefore(text);
    } catch (e) {
      return null;
    }
  }

  static const String bulletPoint = '•';

  List<RTFTextDelta> modifyDeltasForBulletListChange(
    List<RTFTextDelta> modifiedDeltas,
    List<RTFTextDelta> oldDeltas,
  ) {
    final List<String> oldChars = oldDeltas.text.characters.toList();
    final List<String> newChars = modifiedDeltas.text.characters.toList();

    if (oldChars.length > newChars.length) return modifiedDeltas;

    if (newChars.last == '\n') {
      const String value = '\n $bulletPoint ';

      final TextDeltas deltas = modifiedDeltas.copy
        ..replaceRange(
          modifiedDeltas.length - 1,
          modifiedDeltas.length,
          List.generate(
            value.length,
            (index) => RTFTextDelta(
              char: value[index],

              /// adding this check so that the character typed after this does not inherit the bullet point's metadata
              /// hence the restoration back to the [this] controller's [metadata]
              metadata: (index == value.length - 1)
                  ? metadata
                  : RTFTextFieldController.defaultMetadata.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
            ),
          ),
        );

      text = deltas.text;
      selection = TextSelection.collapsed(offset: text.length);

      return deltas;
    }

    return modifiedDeltas;
  }

  TextDeltas compareNewStringAndOldTextDeltasForChanges(
    String text,
    TextDeltas oldDeltas,
  ) {
    if (text.isEmpty) return [];
    final int minLength = min(text.length, oldDeltas.length);

    final TextDeltas deltas =
        oldDeltas.isEmpty ? [] : oldDeltas.sublist(0, minLength);

    if (minLength == oldDeltas.length) {
      final RTFTextMetadata metadata_ =
          oldDeltas.elementAtOrNull(minLength - 1)?.metadata ??
              metadata ??
              RTFTextFieldController.defaultMetadata;

      for (int i = minLength; i < text.length; i++) {
        deltas.add(
          RTFTextDelta(
            char: text[i],
            metadata: metadataToggled ? metadata : metadata_,
          ),
        );
      }
    } else {
      for (int i = minLength; i < oldDeltas.length; i++) {
        deltas.removeLast();
      }
    }

    return deltas;
  }

  void applyDefaultMetadataChange(RTFTextMetadata changedMetadata) {
    metadata = changedMetadata;
  }

  bool get isListMode => indexOflListChar != null;

  int? indexOflListChar;

  void toggleListMode() {
    indexOflListChar = indexOflListChar == null ? (deltas.length - 1) : null;
    _metadataToggled = true;
    notifyListeners();
  }

  void changeStyleOnSelectionChange({
    RTFTextMetadata? changedMetadata,
    required RTFTextMetadataChangeEnum change,
    required TextDeltas modifiedDeltas,
    required TextSelection selection,
  }) {
    if (!selection.isValid) return;
    changedMetadata ??=
        deltas[text.indexOf(selection.textBefore(text).chars.last)].metadata ??
            metadata ??
            RTFTextFieldController.defaultMetadata;

    _metadata = _metadata?.combineWhatChanged(
          change,
          changedMetadata,
        ) ??
        changedMetadata;

    metadataToggled = true;

    if (selection.isCollapsed) return notifyListeners();

    setDeltas(
      applyMetadataToTextInSelection(
        newMetadata: changedMetadata,
        change: change,
        deltas: modifiedDeltas,
        selection: selection,
      ),
    );
    notifyListeners();
  }

  /// Applies the [newMetadata] to the [deltas] in the [selection] by the [change].
  ///
  /// use [RTFTextMetadataChangeEnum.all] to apply change to more than one metadata field change.
  TextDeltas applyMetadataToTextInSelection({
    required RTFTextMetadata newMetadata,
    required TextDeltas deltas,
    required RTFTextMetadataChangeEnum change,
    required TextSelection selection,
  }) {
    final TextDeltas modifiedDeltas = deltas.copy;

    final int start = selection.start;
    final int end = selection.end;

    for (int i = start; i < end; i++) {
      modifiedDeltas[i] = modifiedDeltas[i].copyWith(
        metadata: modifiedDeltas[i].metadata?.combineWhatChanged(
                  change,
                  newMetadata,
                ) ??
            newMetadata,
      );
    }
    return modifiedDeltas;
  }

  /// Toggles the [RTFTextMetadata.fontWeight] between [FontWeight.normal] and [FontWeight.w700].
  void toggleBold() {
    final RTFTextMetadata tempMetadata =
        metadata ?? RTFTextFieldController.defaultMetadata;
    final RTFTextMetadata changedMetadata = tempMetadata.copyWith(
      fontWeight: tempMetadata.fontWeight == FontWeight.normal
          ? FontWeight.w700
          : FontWeight.normal,
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: RTFTextMetadataChangeEnum.fontWeight,
      modifiedDeltas: deltas.copy,
      selection: selection.copyWith(),
    );
  }

  /// Toggles the [RTFTextMetadata.fontStyle] between [FontStyle.normal] and [FontStyle.italic].
  void toggleItalic() {
    final RTFTextMetadata tempMetadata =
        metadata ?? RTFTextFieldController.defaultMetadata;

    final RTFTextMetadata changedMetadata = tempMetadata.copyWith(
      fontStyle: tempMetadata.fontStyle == FontStyle.italic
          ? FontStyle.normal
          : FontStyle.italic,
    );
    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: RTFTextMetadataChangeEnum.fontStyle,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  /// Toggles the [RTFTextMetadata.decoration] between [RTFTextDecorationEnum.none] and [RTFTextDecorationEnum.underline].
  void toggleUnderline() {
    final RTFTextMetadata tempMetadata =
        metadata ?? RTFTextFieldController.defaultMetadata;

    final RTFTextMetadata changedMetadata = tempMetadata.copyWith(
      decoration: tempMetadata.decoration == RTFTextDecorationEnum.underline
          ? RTFTextDecorationEnum.none
          : RTFTextDecorationEnum.underline,
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: RTFTextMetadataChangeEnum.fontDecoration,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  /// Toggles the [RTFTextMetadata.decoration] between [RTFTextDecorationEnum.none] and [RTFTextDecorationEnum.lineThrough].
  void toggleSuperscript() {
    final RTFTextMetadata tempMetadata =
        metadata ?? RTFTextFieldController.defaultMetadata;

    final RTFTextMetadata changedMetadata = tempMetadata.copyWith(
      fontFeatures: tempMetadata.fontFeatures?.firstOrNull ==
              const FontFeature.superscripts()
          ? const []
          : const [FontFeature.superscripts()],
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: RTFTextMetadataChangeEnum.fontFeatures,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  /// Toggles the [RTFTextMetadata.fontFeatures] between empty list and [FontFeature.subscripts()].
  void toggleSubscript() {
    final RTFTextMetadata tempMetadata =
        metadata ?? RTFTextFieldController.defaultMetadata;

    final RTFTextMetadata changedMetadata = tempMetadata.copyWith(
      fontFeatures: tempMetadata.fontFeatures?.firstOrNull ==
              const FontFeature.subscripts()
          ? const []
          : const [FontFeature.subscripts()],
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: RTFTextMetadataChangeEnum.fontFeatures,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  void changeColor(Color color) {
    final RTFTextMetadata changedMetadata =
        (metadata ?? RTFTextFieldController.defaultMetadata).copyWith(
      color: color,
    );
    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: RTFTextMetadataChangeEnum.fontStyle,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  void changeFontSize(double fontSize) {
    final RTFTextMetadata changedMetadata =
        (metadata ?? RTFTextFieldController.defaultMetadata).copyWith(
      fontSize: fontSize,
    );
    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: RTFTextMetadataChangeEnum.fontSize,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  /// Changes the [RTFTextMetadata.alignment] to the given [alignment].
  ///
  /// note that you have to use [RichTextField] for changes made by this method to reflect.
  /// or otherwise set the [TextField.alignment] parameter of your textfield to [RTFTextMetadata.alignment]
  /// while listening to changes in the controller.
  /// example:
  ///...
  ///     ValueListenableBuilder<TextEditingValue>(
  ///         valueListenable: controller,
  ///         builder: (_, controllerValue, __) => TextField(
  ///           controller: controller,
  ///           textAlign: controller.metadata?.alignment ?? TextAlign.start,
  ///         ),
  ///       ),
  /// ...
  void changeAlignment(TextAlign alignment) {
    applyDefaultMetadataChange(
      (metadata ?? RTFTextFieldController.defaultMetadata)
          .copyWith(alignment: alignment),
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> spanChildren = [];

    for (final RTFTextDelta delta in deltas) {
      spanChildren.add(
        TextSpan(
          text: delta.char,
          style: delta.metadata?.style ??
              RTFTextFieldController.defaultMetadata.style,
        ),
      );
    }

    final TextSpan textSpan = TextSpan(
      style: metadata?.styleWithoutFontFeatures ?? style,
      children: spanChildren,
    );
    return textSpan;
  }

  @override
  void dispose() {
    removeListener(_internalControllerListener);
    super.dispose();
  }
}
