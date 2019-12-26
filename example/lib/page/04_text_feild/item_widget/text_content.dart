import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stone_flutter_kit/stone_flutter_kit.dart';

import '../models.dart';

/// 消息文本样式
const TextStyle _kDefaultTextStyle = const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400);
/// 消息内边距
const EdgeInsets _kContentPadding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
/// 消息内容尺寸约束
const BoxConstraints _kContentConstraints = const BoxConstraints(minWidth: 40.0, minHeight: 40.0);

/// 文本消息内容
class TextContent extends StatelessWidget {
  TextContent({Key key, this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _kContentPadding,
      constraints: _kContentConstraints,
      decoration: BoxDecoration(
        color: message.isReceived ? Color(0xFF5AE7C9) : Color(0xFFFF767C),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IntrinsicWidth(
        child: Center(
          child: Text(
            message.content,
            softWrap: true,
            style: _kDefaultTextStyle.copyWith(color: message.isReceived ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }

  /// 计算消息尺寸
  static Size computeSize({double maxContentWidth, Message message}) {
    print(maxContentWidth);
    final textSize = message.content.computeParagraphSize(textStyle: _kDefaultTextStyle, maxWidth: maxContentWidth);
    return Size(
      math.max(textSize.width + _kContentPadding.horizontal, _kContentConstraints.minWidth),
      math.max(textSize.height + _kContentPadding.vertical, _kContentConstraints.minHeight),
    );
  }
}