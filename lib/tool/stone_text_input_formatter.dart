import 'package:flutter/services.dart';

/// 数字文本输入格式化器
class StoneNumberTextInputFormatter extends TextInputFormatter {
  StoneNumberTextInputFormatter({
    this.minimumFractionDigits = 0,
    this.maximumFractionDigits = 2,
  }) : pattern = maximumFractionDigits == 0 ? RegExp(r'^\d*$') : RegExp(r'^(\d*\.?\d{0,' + '$maximumFractionDigits' + r'})?$');

  final int minimumFractionDigits;
  final int maximumFractionDigits;
  final RegExp pattern;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!pattern.hasMatch(newValue.text)) {
      return oldValue;
    }

    return _selectionAwareTextManipulation(newValue, (String substring) {
      return pattern
          .allMatches(substring)
          .map<String>((Match match) => match.group(0))
          .join();
    } ,
    );
  }
}

TextEditingValue _selectionAwareTextManipulation(TextEditingValue value, String substringManipulation(String substring)) {
  final int selectionStartIndex = value.selection.baseOffset;
  final int selectionEndIndex = value.selection.extentOffset;

  String manipulatedText;
  TextSelection manipulatedSelection;

  if (selectionStartIndex < 0 || selectionEndIndex < 0) {
    manipulatedText = substringManipulation(value.text);
  } else {
    final String beforeSelection = substringManipulation(value.text.substring(0, selectionStartIndex));
    final String inSelection = substringManipulation(value.text.substring(selectionStartIndex, selectionEndIndex));
    final String afterSelection = substringManipulation(value.text.substring(selectionEndIndex));
    manipulatedText = beforeSelection + inSelection + afterSelection;

    if (value.selection.baseOffset > value.selection.extentOffset) {
      manipulatedSelection = value.selection.copyWith(
        baseOffset: beforeSelection.length + inSelection.length,
        extentOffset: beforeSelection.length,
      );
    } else {
      manipulatedSelection = value.selection.copyWith(
        baseOffset: beforeSelection.length,
        extentOffset: beforeSelection.length + inSelection.length,
      );
    }
  }

  return TextEditingValue(
    text: manipulatedText,
    selection: manipulatedSelection ?? const TextSelection.collapsed(offset: -1),
    composing: manipulatedText == value.text ? value.composing : TextRange.empty,
  );
}