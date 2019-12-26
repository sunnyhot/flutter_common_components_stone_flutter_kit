import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:stone_flutter_kit/stone_flutter_kit.dart';

import 'item_widget/message_item.dart';

import 'models.dart';

/// [StoneTextField]
class TextFieldDemoPage extends StatefulWidget {
  @override
  _TextFieldDemoPageState createState() => _TextFieldDemoPageState();
}

class _TextFieldDemoPageState extends State<TextFieldDemoPage> {
  final AutoScrollController _scrollController = AutoScrollController();
  final FocusNode _textFieldFocusNode = FocusNode();

  List<Message> _messages = [];

  @override
  void initState() {
    _loadMessages().then((messages) {
      SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
        _messages = messages;
        _scrollToBottom(animated: false);
      }));
    });

    _textFieldFocusNode.addListener(() {
      if (_textFieldFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 150), () => _scrollToBottom(animated: true));
      }
    });

    super.initState();
  }

  /// 将消息列表滚动到底部
  void _scrollToBottom({bool animated}) {
    _scrollController.scrollToIndex(_messages.length - 1, duration: Duration(milliseconds: 150));
  }

  /// 收起键盘（点击空白处、拖动列表）
  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('TextField'),
      centerTitle: true,
      leading: StoneBackButton(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(child: _buildList()),
        _buildFooter(),
      ],
    );
  }

  Widget _buildList() {
    return GestureDetector(
      onTapDown: (_) {
        _dismissKeyboard();
        _scrollToBottom(animated: false);
      },
      child: AbsorbPointer(
        absorbing: _textFieldFocusNode.hasFocus,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          controller: _scrollController,
          itemCount: _messages.length,
          itemBuilder: (_, index) => AutoScrollTag(
            key: ValueKey(index),
            controller: _scrollController,
            index: index,
            child: MessageItem(message: _messages[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      color: Colors.white,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45, width: 1.0 / window.devicePixelRatio),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: CupertinoTextField(
            focusNode: _textFieldFocusNode,
            scrollPadding: EdgeInsets.zero,
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w400),
            onChanged: (_) => _scrollToBottom(animated: true),
          ),
        ),
      ),
    );
  }
}

Future<List<Message>> _loadMessages() async {
  final random = Random();
  final content = () {
    final str = StringBuffer();
    final count = random.nextInt(10);
    for (int i = 0; i < count; i++) {
      str.write(i == count - 1 ? 'hello world' : 'hello world ');
    }
    return str.isNotEmpty ? str.toString() : 'hello world';
  };

  final friend = Friend(id: '1', nickName: '小妮', avatarUrl: '');
  final session = Session(id: '1', friend: friend, lastMessage: '');

  return List.generate(20, (index) => Message(
    id: '$index',
    content: content(),
    friend: random.nextInt(2) == 1 ? friend : null,
    session: session,
    type: MessageType.text,
  )).toList();
}