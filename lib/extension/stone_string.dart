import 'dart:ui' as ui show ParagraphBuilder, ParagraphConstraints, ParagraphStyle;

import 'package:flutter/material.dart';

extension StoneString on String {
  /// 计算一段特定样式的文本段落的尺寸
  ///
  /// TODO：目前两种方式都计算不准确
  Size computeParagraphSize({
    TextStyle textStyle,
    TextAlign textAlign = TextAlign.left,
    TextDirection textDirection: TextDirection.ltr,
    String ellipsis,
    double maxWidth = double.infinity,
  }) {
    // 段落样式，用于计算尺寸
    final paragraphStyle = ui.ParagraphStyle(
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: null,
      fontFamily: textStyle.fontFamily,
      fontSize: textStyle.fontSize,
      height: textStyle.height,
      fontWeight: textStyle.fontWeight,
      fontStyle: textStyle.fontStyle,
      strutStyle: null,
      ellipsis: ellipsis,
      locale: textStyle.locale,
    );

    final builder  = ui.ParagraphBuilder(paragraphStyle)..addText(this);
    final paragraph = builder.build()..layout(ui.ParagraphConstraints(width: maxWidth));
    return Size(paragraph.width, paragraph.height);

//    final textPainter = TextPainter(
//      text: TextSpan(style: textStyle),
//      textAlign: textAlign,
//      textDirection: textDirection,
//      ellipsis: ellipsis,
//      maxLines: null,
//    );
//    textPainter.layout(maxWidth: maxWidth);
//    return textPainter.size;
  }
}