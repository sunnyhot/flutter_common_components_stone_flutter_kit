import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:stone_flutter_kit_example/page/04_text_feild/item_widget/text_content.dart';

import '../models.dart';

/// 头像尺寸
const _kAvatarSize = 40.0;
/// 头像圆角半径
const _kAvatarRadius = 4.0;

/// 消息垂直方向内边距
const _kMessageVerticalPadding = 12.0;
/// 头像到边界的间隔
const _kAvatarToEdgeSpacing = 12.0;
/// 内容到头像的间隔
const _kContentToAvatarSpacing = 12.0;
/// 内容到边界的间隔
const _kContentToEdgeSpacing = 100.0;

/// 消息 Item
class MessageItem extends StatelessWidget {
  MessageItem({Key key, this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      _buildAvatar(),
      SizedBox(width: _kContentToAvatarSpacing),
      Flexible(child: _buildContent()),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        message.isReceived ? _kAvatarToEdgeSpacing : _kContentToEdgeSpacing,
        _kMessageVerticalPadding,
        message.isReceived ? _kContentToEdgeSpacing : _kAvatarToEdgeSpacing,
        _kMessageVerticalPadding,
      ),
      child: Row(
        mainAxisAlignment: message.isReceived ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: message.isReceived ? items : items.reversed.toList(),
      ),
    );
  }

  Widget _buildAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_kAvatarRadius),
      child: Container(
        width: _kAvatarSize,
        height: _kAvatarSize,
        color: message.isReceived ? Color(0xFF5AE7C9) : Color(0xFFFF767C),
      ),
    );
  }

  Widget _buildContent() {
    switch (message.type) {
      case MessageType.text:
        return TextContent(message: message);
      case MessageType.image:
      case MessageType.audio:
      case MessageType.video:
      case MessageType.location:
      case MessageType.tips:
      case MessageType.command:
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            '此类型消息暂时不支持展示！',
            style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w400),
          ),
        );
    }

    return null;
  }

  /// 计算消息尺寸
  static Size computeSize({double itemWidth, Message message}) {
    itemWidth = itemWidth ?? ui.window.physicalSize.width / ui.window.devicePixelRatio;
    final maxContentWidth = itemWidth - _kAvatarToEdgeSpacing - _kAvatarSize - _kContentToAvatarSpacing - _kContentToEdgeSpacing;

    switch (message.type) {
      case MessageType.text:
        final contentSize = TextContent.computeSize(maxContentWidth: maxContentWidth, message: message);
        return Size(
          _kAvatarToEdgeSpacing + _kAvatarSize + _kContentToAvatarSpacing + contentSize.width + _kContentToEdgeSpacing,
          _kMessageVerticalPadding * 2 + contentSize.height,
        );
      case MessageType.image:
        return Size(0.0, 0.0);
      case MessageType.audio:
        return Size(0.0, 0.0);
      case MessageType.video:
        return Size(0.0, 0.0);
      case MessageType.location:
        return Size(0.0, 0.0);
      case MessageType.tips:
        return Size(0.0, 0.0);
      case MessageType.command:
        return Size(0.0, 0.0);
    }

    return Size(0.0, 0.0);
  }
}