import 'dart:async';

import 'package:flutter/material.dart';

/// 可以按照一定周期计数的组件
///
/// 通过用来构建一个倒计时组件，例如一个倒计时按钮。
///
/// {@tool sample}
///
/// 一个 5 秒倒计时结束后才可以点击按钮。
///
/// ```dart
/// StoneCounterBuilder(
///   duration: Duration(seconds: 1),
///   count: 5,
///   builder: (context, number, finished) => StoneButton(
///     onPressed: finished ? () => print('number: $number') : null;
///     child: Text('确定' + (finished ? '' : '（${5 - number}）')),
///   ),
/// );
/// ```
/// {@end-tool}
class StoneCounterBuilder extends StatefulWidget {
  const StoneCounterBuilder({
    Key key,
    @required this.duration,
    @required this.count,
    @required this.builder,
  }) : assert(count > 0), super(key: key);

  final Duration duration;
  final int count;
  final Widget Function(BuildContext context, int number, bool finished) builder;

  @override
  _StoneCounterBuilderState createState() => _StoneCounterBuilderState();
}

class _StoneCounterBuilderState extends State<StoneCounterBuilder> {
  Timer _timer;
  int _number = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(widget.duration, (timer) {
      if (++_number == widget.count) {
        timer.cancel();
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _number, _number == widget.count);
  }
}