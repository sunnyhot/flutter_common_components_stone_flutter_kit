import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stone_flutter_kit/widget/stone_ink_ripple.dart';

const Duration _kAnimationDuration = const Duration(milliseconds: 150);

/// [StoneItemType] 类型
enum StoneItemType {
  /// Material 风格，按下后有涟漪动画
  material,
  /// Cupertino 风格，按下后有渐变动画
  cupertino,
}

/// 跟随平台高亮风格的单元格
///
/// 通常在 [ListView]、[CustomScrollView]、[GridView] 中使用
class StoneItem extends StatelessWidget {
  const StoneItem({
    Key key,
    this.onTap,
    this.type,
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
    this.color,
    this.decoration,
    this.highlightColor,
    this.splashShape,
    @required this.child,
    this.divider,
  }) : assert(color == null || decoration == null, 'color 和 decoration 不能同时使用'), super(key: key);

  final VoidCallback onTap;
  final StoneItemType type;
  final EdgeInsets padding;
  final Color color;
  final BorderRadius borderRadius;
  final Decoration decoration;
  final Color highlightColor;
  final ShapeBorder splashShape;
  final Widget child;
  final Divider divider;

  @override
  Widget build(BuildContext context) {
    final itemType = type ?? (Platform.isIOS ? StoneItemType.cupertino : StoneItemType.material);
    final content = Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        itemType == StoneItemType.cupertino
            ? _CupertinoItem(onTap: onTap, padding: padding, highlightColor: highlightColor, child: child,)
            : _MaterialItem(onTap: onTap, padding: padding, highlightColor: highlightColor, splashShape: splashShape, child: child),
        if (divider != null)
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: divider,
          ),
      ],
    );

    return Container(
      decoration: this.decoration ?? BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: content,
      ),
    );
  }
}

/// Material 风格的单元格，点击后有涟漪效果
class _MaterialItem extends StatefulWidget {
  const _MaterialItem({
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.highlightColor,
    this.splashShape,
    this.child,
  });

  final VoidCallback onTap;
  final EdgeInsets padding;
  final Color highlightColor;
  final ShapeBorder splashShape;
  final Widget child;

  @override
  _MaterialItemState createState() => _MaterialItemState();
}

class _MaterialItemState extends State<_MaterialItem> {
  bool get _enabled => widget.onTap != null;
  bool _buttonHeldDown = false;

  int get _nowTime => DateTime.now().millisecondsSinceEpoch;
  int _tapDownTime = 0;
  Timer _callbackTimer;

  @override
  void dispose() {
    _callbackTimer?.cancel();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails event) {
    if (_buttonHeldDown) {
      return;
    }

    _buttonHeldDown = true;
    _callbackTimer?.cancel();
    _tapDownTime = _nowTime;
  }

  void _handleTapCancel() {
    if (!_buttonHeldDown) {
      return;
    }

    void handle() {
      _buttonHeldDown = false;
      _tapDownTime = 0;
    }

    final countdown = _nowTime - _tapDownTime;
    if (countdown >= _kAnimationDuration.inMilliseconds) {
      handle();
    } else {
      _callbackTimer = Timer(Duration(milliseconds: _kAnimationDuration.inMilliseconds - countdown), handle);
    }
  }

  void _handleTap() {
    if (!_buttonHeldDown) {
      return;
    }

    void handle() {
      _buttonHeldDown = false;
      widget.onTap();
    }

    final countdown = _nowTime - _tapDownTime;
    if (countdown >= _kAnimationDuration.inMilliseconds) {
      handle();
    } else {
      _callbackTimer = Timer(Duration(milliseconds: _kAnimationDuration.inMilliseconds - countdown), handle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: _enabled ? _handleTap : null,
        onTapDown: _enabled ? _handleTapDown : null,
        onTapCancel: _enabled ? _handleTapCancel : null,
        splashColor: widget.highlightColor,
        highlightColor: Colors.transparent,
        splashFactory: StoneInkRipple.splashFactory,
        customBorder: widget.splashShape,
        child: Padding(
          padding: widget.padding,
          child: Center(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Cupertino 风格的单元格，点击后有渐变高亮效果
class _CupertinoItem extends StatefulWidget {
  const _CupertinoItem({
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.highlightColor,
    this.child,
  });

  final VoidCallback onTap;
  final EdgeInsets padding;
  final Color highlightColor;
  final Widget child;

  @override
  _CupertinoItemState createState() => _CupertinoItemState();
}

class _CupertinoItemState extends State<_CupertinoItem> with TickerProviderStateMixin {
  bool get _enabled => widget.onTap != null;
  bool _buttonHeldDown = false;

  final Tween<double> _opacityTween = Tween<double>(begin: 0.0, end: 1.0);
  AnimationController _animationController;
  Animation<double> _opacityAnimation;

  int get _nowTime => DateTime.now().millisecondsSinceEpoch;
  int _tapDownTime = 0;
  Timer _callbackTimer;

  @override
  void dispose() {
    _animationController.dispose();
    _callbackTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: _kAnimationDuration, value: 0.0, vsync: this);
    _opacityAnimation = _animationController.drive(CurveTween(curve: Curves.decelerate)).drive(_opacityTween);
  }

  void _handleTapDown(TapDownDetails event) {
    if (_buttonHeldDown) {
      return;
    }

    _buttonHeldDown = true;
    _animate();

    _callbackTimer?.cancel();
    _tapDownTime = _nowTime;
  }

  void _handleTapCancel() {
    if (!_buttonHeldDown) {
      return;
    }

    void handle() {
      _buttonHeldDown = false;
      _animate();
      _tapDownTime = 0;
    }

    final countdown = _nowTime - _tapDownTime;
    if (countdown >= _kAnimationDuration.inMilliseconds) {
      handle();
    } else {
      _callbackTimer = Timer(Duration(milliseconds: _kAnimationDuration.inMilliseconds - countdown), handle);
    }
  }

  void _handleTap() {
    if (!_buttonHeldDown) {
      return;
    }

    void handle() {
      _buttonHeldDown = false;
      _animate();
      widget.onTap();
    }

    final countdown = _nowTime - _tapDownTime;
    if (countdown >= _kAnimationDuration.inMilliseconds) {
      handle();
    } else {
      _callbackTimer = Timer(Duration(milliseconds: _kAnimationDuration.inMilliseconds - countdown), handle);
    }
  }

  void _animate() {
    if (_animationController.isAnimating) {
      return;
    }

    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: _kAnimationDuration)
        : _animationController.animateTo(0.0, duration: _kAnimationDuration);

    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _enabled ? _handleTapDown : null,
      onTapCancel: _enabled ? _handleTapCancel : null,
      onTap: _enabled ? _handleTap : null,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Container(color: widget.highlightColor ?? Theme.of(context).highlightColor),
            ),
          ),
          Padding(
            padding: widget.padding,
            child: Center(
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}