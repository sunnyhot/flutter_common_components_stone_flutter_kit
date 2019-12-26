import 'dart:async';

import 'package:flutter/widgets.dart';

typedef TapGestureDownCallback(TapDownDetails details, int tapCount);
typedef TapGestureUpCallback(TapUpDetails details, int tapCount);
typedef TapGestureCancelCallback(int tapCount);

class StoneTapGestureDetector extends StatefulWidget {
  StoneTapGestureDetector({
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onTapCancel,
    this.numberOfTapsRequired = 1,
    this.behavior,
    this.child,
  });

  final TapGestureDownCallback onTapDown;
  final TapGestureUpCallback onTapUp;
  final VoidCallback onTap;
  final TapGestureCancelCallback onTapCancel;
  final int numberOfTapsRequired;
  final HitTestBehavior behavior;
  final Widget child;

  @override
  _StoneTapGestureDetectorState createState() => _StoneTapGestureDetectorState();
}

class _StoneTapGestureDetectorState extends State<StoneTapGestureDetector> {
  Timer _tapTimer;
  int _tapCount = 0;

  @override
  void dispose() {
    _tapTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => widget.onTapDown != null ? widget.onTapDown(details, _tapCount) : (){},
      onTapUp: (details) => widget.onTapUp != null ? widget.onTapUp(details, _tapCount) : (){},
      onTap: _startTapTimer,
      onTapCancel: () => widget.onTapCancel != null ? widget.onTapCancel(_tapCount) : (){},
      child: widget.child,
      behavior: widget.behavior,
    );
  }

  void _startTapTimer() {
    _tapCount++;
    _stopTapTimer();

    if (_tapCount == widget.numberOfTapsRequired) {
      _tapCount = 0;
      widget.onTap();
    } else {
      _tapTimer = Timer(const Duration(milliseconds: 300), () {
        _tapCount = 0;
        _stopTapTimer();
      });
    }
  }

  void _stopTapTimer() {
    if (_tapTimer != null) {
      _tapTimer.cancel();
      _tapTimer = null;
    }
  }
}