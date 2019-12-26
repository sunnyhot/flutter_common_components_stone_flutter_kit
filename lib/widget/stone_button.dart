import 'dart:async';
import 'dart:math' as math;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stone_flutter_kit/widget/stone_ink_ripple.dart';

const Duration _kAnimationDuration = const Duration(milliseconds: 225);

/// [StoneButton] 状态
enum StoneButtonState {
  /// 正常状态
  normal,
  /// 高亮状态
  highlighted,
  /// 禁用状态
  disabled,
}

/// [StoneButton] 内容构建器
typedef StoneButtonContentBuilder = Widget Function(BuildContext context, StoneButtonState state);

/// [StoneButton] 类型
enum StoneButtonType {
  /// Material 风格，按下后有涟漪动画
  material,
  /// Cupertino 风格，按下后有渐变动画
  cupertino,
}

/// 按钮
class StoneButton extends StatefulWidget {
  const StoneButton({
    Key key,
    this.onPressed,
    this.onLongPressed,
    this.styleKey,
    this.type,
    this.textStyle,
    this.highlightTextStyle,
    this.disabledTextStyle,
    this.color,
    this.highlightColor,
    this.disabledColor,
    this.gradient,
    this.highlightGradient,
    this.disabledGradient,
    this.borderSide,
    this.highlightBorderSide,
    this.disabledBorderSide,
    this.borderRadius,
    this.highlightBorderRadius,
    this.disabledBorderRadius,
    this.background,
    this.highlightBackground,
    this.disabledBackground,
    this.elevation,
    this.highlightElevation,
    this.disabledElevation,
    this.shape,
    this.highlightShape,
    this.disabledShape,
    this.splashColor,
    this.splashShape,
    this.pressedOpacity,
    this.padding,
    this.width,
    this.height,
    this.constraints,
    this.tapTargetSize,
    this.child,
    this.builder,
  })  : assert(color == null || gradient == null, 'color 与 gradient 不能同时使用'),
        assert(highlightColor == null || highlightGradient == null, 'highlightColor 与 highlightGradient 不能同时使用'),
        assert(disabledColor == null || disabledGradient == null, 'disabledColor 与 disabledGradient 不能同时使用'),
        assert(borderSide == null || shape == null, 'borderSide 与 shape 不能同时使用'),
        assert(highlightBorderSide == null || highlightShape == null, 'highlightBorderSide 与 highlightShape 不能同时使用'),
        assert(disabledBorderSide == null || disabledShape == null, 'disabledBorderSide 与 disabledShape 不能同时使用'),
        assert(pressedOpacity == null || (pressedOpacity >= 0.1 && pressedOpacity <= 1.0), 'pressedOpacity 的取值为 0.1~1.0'),
        assert(child == null || builder == null, 'child 与 builder 不能同时使用'),
        assert(child != null || builder != null, 'child 或 builder 不能同时为 null'),
        super(key: key);



  /// 点击后的回调
  final VoidCallback onPressed;
  /// 按钮被长按的回调
  final VoidCallback onLongPressed;

  /// 按钮样式 key，从 [StoneButtonTheme.of(context).styles[styleKey]] 中获取
  final String styleKey;
  /// 按钮类型，默认跟随平台
  final StoneButtonType type;

  /// 正常状态下的文本样式
  final TextStyle textStyle;
  /// 高亮状态下的文本样式
  final TextStyle highlightTextStyle;
  /// 禁用状态下的文本样式
  final TextStyle disabledTextStyle;

  /// 正常状态下填充颜色
  final Color color;

  /// 高亮状态下的填充颜色
  final Color highlightColor;
  /// 禁用状态下的填充颜色
  final Color disabledColor;

  /// 正常状态下渐变填充
  final Gradient gradient;
  /// 高亮状态下的渐变填充
  final Gradient highlightGradient;
  /// 禁用状态下的渐变填充
  final Gradient disabledGradient;

  /// 正常状态下边框
  final BorderSide borderSide;
  /// 高亮状态下的边框
  final BorderSide highlightBorderSide;
  /// 禁用状态下的边框
  final BorderSide disabledBorderSide;

  /// 正常状态下边框圆角
  final BorderRadius borderRadius;
  /// 高亮状态下的边框圆角
  final BorderRadius highlightBorderRadius;
  /// 禁用状态下的边框圆角
  final BorderRadius disabledBorderRadius;

  /// 正常状态下背景
  final Widget background;
  /// 高亮状态下的背景
  final Widget highlightBackground;
  /// 禁用状态下的背景
  final Widget disabledBackground;

  /// 正常状态下的阴影半径
  final double elevation;
  /// 高亮状态下的阴影半径
  final double highlightElevation;
  /// 禁用状态下的阴影半径
  final double disabledElevation;

  /// 正常状态下的形状
  final ShapeBorder shape;
  /// 高亮状态下的形状
  final ShapeBorder highlightShape;
  /// 正常状态下的形状
  final ShapeBorder disabledShape;

  /// splash 颜色，作用于 [StoneButtonType.material] 风格的按钮
  final Color splashColor;
  /// splash 形状，作用于 [StoneButtonType.material] 风格的按钮
  final ShapeBorder splashShape;

  /// 按下后的不透明度，作用于 [StoneButtonType.cupertino] 风格的按钮
  ///
  /// 当 [highlightColor] 或 [highlightGradient] 或 [highlightBackground] 不为 null 时，[pressedOpacity] 将被忽略。
  final double pressedOpacity;

  /// 内边距
  final EdgeInsetsGeometry padding;
  /// 固定宽度
  final double width;
  /// 固定高度
  final double height;

  /// 尺寸约束
  final BoxConstraints constraints;
  /// 最小点击区域
  final Size tapTargetSize;

  /// 按钮内容组件
  final Widget child;
  /// 按钮内容构建器
  final StoneButtonContentBuilder builder;

  /// 是否为正常状态
  bool get enabled => onPressed != null || onLongPressed != null;
  /// 是否为禁用状态
  bool get disabled => onPressed == null && onLongPressed == null;

  @override
  _StoneButtonState createState() => _StoneButtonState();
}

class _StoneButtonState extends State<StoneButton> with TickerProviderStateMixin {
  /// 按钮类型，默认跟随平台
  StoneButtonType _type;
  /// 按钮使用的样式
  StoneButtonStyle _style;

  /// 当前是否高亮
  bool _highlighted = false;

  /// 当前状态下的文本样式
  TextStyle get _effectiveTextStyle {
    final normalTextStyle = () => (widget.textStyle ?? _style?.textStyle) ?? Theme.of(context).textTheme.button;

    if (widget.disabled) {
      return (widget.disabledTextStyle ?? _style?.disabledTextStyle) ?? normalTextStyle();
    }

    if (_highlighted) {
      return (widget.highlightTextStyle ?? _style?.highlightTextStyle) ?? normalTextStyle();
    }

    return normalTextStyle();
  }

  /// 当前状态下的 IconThemeData
  IconThemeData get _effectiveIconThemeData {
    return IconTheme.of(context).copyWith(color: _effectiveTextStyle.color);
  }

  /// 当前状态下的填充颜色
  Color get _effectiveColor {
    final normalColor = () => (widget.color ?? _style?.color);

    if (widget.disabled) {
      return (widget.disabledColor ?? _style?.disabledColor) ??
          (widget.disabledGradient != null || _style?.disabledGradient != null ? null : normalColor());
    }

    if (_highlighted) {
      return (widget.highlightColor ?? _style?.highlightColor) ??
          (widget.highlightGradient != null || _style?.highlightGradient != null ? null : normalColor());
    }

    return normalColor();
  }

  /// 当前状态下渐变填充
  Gradient get _effectiveGradient {
    final normalGradient = () => (widget.gradient ?? _style?.gradient);

    if (widget.disabled) {
      return (widget.disabledGradient ?? _style?.disabledGradient) ??
          (widget.disabledColor != null || _style?.disabledColor != null ? null : normalGradient());
    }

    if (_highlighted) {
      return (widget.highlightGradient ?? _style?.highlightGradient) ??
          (widget.highlightColor != null || _style?.highlightColor != null ? null : normalGradient());
    }

    return normalGradient();
  }

  /// 当前状态下边框
  BorderSide get _effectiveBorderSide {
    final normalBorderSide = () => (widget.borderSide ?? _style?.borderSide);

    if (widget.disabled) {
      return (widget.disabledBorderSide ?? _style?.disabledBorderSide) ?? normalBorderSide();
    }

    if (_highlighted) {
      return (widget.highlightBorderSide ?? _style?.highlightBorderSide) ?? normalBorderSide();
    }

    return normalBorderSide();
  }

  /// 当前状态下边框圆角
  BorderRadius get _effectiveBorderRadius {
    final normalBorderRadius = () => (widget.borderRadius ?? _style?.borderRadius);

    if (widget.disabled) {
      return (widget.disabledBorderRadius ?? _style?.disabledBorderRadius) ?? normalBorderRadius();
    }

    if (_highlighted) {
      return (widget.highlightBorderRadius ?? _style?.highlightBorderRadius) ?? normalBorderRadius();
    }

    return normalBorderRadius();
  }

  /// 当前状态下的背景
  Widget get _effectiveBackground {
    final normalBackground = () => widget.background ?? _style?.background;

    if (widget.disabled) {
      return (widget.disabledBackground ?? _style?.disabledBackground) ?? normalBackground();
    }

    if (_highlighted) {
      return (widget.highlightBackground ?? _style?.highlightBackground) ?? normalBackground();
    }

    return normalBackground();
  }

  /// 当前状态下的阴影
  double get _effectiveElevation {
    final normalElevation = () => (widget.elevation ?? _style?.elevation) ?? 0.0;

    if (widget.disabled) {
      return (widget.disabledElevation ?? _style?.disabledElevation) ?? 0.0;
    }

    if (_highlighted) {
      return (widget.highlightElevation ?? _style?.highlightElevation) ?? normalElevation();
    }

    return normalElevation();
  }

  /// 当前状态下的形状
  ShapeBorder get _effectiveShape {
    final normalShape = () => (widget.shape ?? _style?.shape) ?? RoundedRectangleBorder(
      side: _effectiveBorderSide ?? BorderSide.none,
      borderRadius: _effectiveBorderRadius ?? BorderRadius.zero,
    );

    if (widget.disabled) {
      return (widget.disabledShape ?? _style?.disabledShape) ?? normalShape();
    }

    if (_highlighted) {
      return (widget.highlightShape ?? _style?.highlightShape) ?? normalShape();
    }

    return normalShape();
  }

  /// splash 颜色，作用于 [StoneButtonType.material] 风格的按钮
  Color get _splashColor {
    return widget.splashColor ?? _style?.splashColor;
  }

  /// splash 形状，作用于 [StoneButtonType.material] 风格的按钮
  ShapeBorder get _splashShape {
    return widget.splashShape ?? _style?.splashShape;
  }

  /// 按下后的不透明度，作用于 [StoneButtonType.cupertino] 风格的按钮
  ///
  /// 当 [highlightColor] 或 [highlightGradient] 或 [highlightBackground] 不为 null 时，[pressedOpacity] 将被忽略。
  double get _pressedOpacity {
    if (widget.highlightColor != null || _style?.highlightColor != null
        || widget.highlightGradient != null || _style?.highlightGradient != null
        || widget.highlightBackground != null || _style?.highlightBackground != null) {
      return 1.0;
    }

    return (widget.pressedOpacity ?? _style?.pressedOpacity) ?? 0.3;
  }

  /// 内边距
  EdgeInsetsGeometry get _padding {
    return (widget.padding ?? _style?.padding) ?? EdgeInsets.zero;
  }

  /// 固定宽度
  double get _width {
    return widget.width ?? _style?.width;
  }

  /// 固定高度
  double get _height {
    return widget.height ?? _style?.height;
  }

  /// 尺寸约束
  BoxConstraints get _constraints {
    return (widget.constraints ?? _style?.constraints) ?? const BoxConstraints();
  }

  /// 最小点击区域
  Size get _tapTargetSize {
    return (widget.tapTargetSize ?? _style?.tapTargetSize) ?? Size.zero;
  }

  @override
  Widget build(BuildContext context) {
    _style = widget.styleKey == null ? null : StoneButtonTheme.of(context).styles[widget.styleKey];
    _type = widget.type ?? (Platform.isIOS ? StoneButtonType.cupertino : StoneButtonType.material);

    final content = _InputPadding(
      minSize: _tapTargetSize,
      child: Padding(
        padding: _padding,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            IconTheme(
              data: _effectiveIconThemeData,
              child: widget.child ?? widget.builder(context, () {
                if (widget.disabled) {
                  return StoneButtonState.disabled;
                }
                if (_highlighted) {
                  return StoneButtonState.highlighted;
                }
                return StoneButtonState.normal;
              }()),
            ),
          ],
        ),
      ),
    );

    final interior = _ButtonInterior(
      color: _effectiveColor,
      gradient: _effectiveGradient,
      background: _effectiveBackground,
      elevation: _effectiveElevation,
      shadowColor: _effectiveElevation == 0.0 || (_effectiveColor == null && _effectiveGradient == null)
          ? Colors.transparent
          : Colors.black,
      shape: _effectiveShape,
      curve: Curves.fastOutSlowIn,
      animationDuration: _kAnimationDuration,
      child: _type == StoneButtonType.material ? _buildMaterialButton(child: content) : content,
    );

    return Opacity(
      opacity: widget.enabled
          || widget.disabledColor != null || _style?.disabledColor != null
          || widget.disabledGradient != null || _style?.disabledGradient != null
          || widget.disabledShape != null || _style?.disabledShape != null
          ? 1.0 : 0.6,
      child: AnimatedContainer(
        width: _width,
        height: _height,
        constraints: _constraints,
        curve: Curves.fastOutSlowIn,
        duration: _kAnimationDuration,
        child: _type == StoneButtonType.material ? interior : _buildCupertinoButton(child: interior),
      ),
    );
  }

  /// 构建 Material 风格的按钮
  Widget _buildMaterialButton({Widget child}) {
    return _MaterialButton(
      onPressed: widget.onPressed,
      onLongPressed: widget.onLongPressed,
      onHighlightChanged: (highlight) => setState(() => _highlighted = highlight),
      textStyle: _effectiveTextStyle,
      splashColor: _splashColor,
      splashShape: _splashShape,
      child: child,
    );
  }

  /// 构建 Cupertino 风格的按钮
  Widget _buildCupertinoButton({Widget child}) {
    return _CupertinoButton(
      onPressed: widget.onPressed,
      onLongPressed: widget.onLongPressed,
      onHighlightChanged: (highlight) => setState(() => _highlighted = highlight),
      textStyle: _effectiveTextStyle,
      pressedOpacity: _pressedOpacity,
      child: child,
    );
  }
}

/// Material 风格的按钮
class _MaterialButton extends StatefulWidget {
  const _MaterialButton({
    this.onPressed,
    this.onLongPressed,
    this.onHighlightChanged,
    this.textStyle,
    this.splashColor,
    this.splashShape,
    this.child,
  });

  /// 按钮被按下的回调
  final VoidCallback onPressed;
  /// 按钮被长按的回调
  final VoidCallback onLongPressed;
  /// 高亮状态改变后的回调
  final ValueChanged<bool> onHighlightChanged;

  /// 文本样式
  final TextStyle textStyle;
  /// splash 颜色
  final Color splashColor;
  /// splash 形状
  final ShapeBorder splashShape;

  /// 子组件
  final Widget child;

  @override
  __MaterialButtonState createState() => __MaterialButtonState();
}

class __MaterialButtonState extends State<_MaterialButton> {
  bool get _enabled => widget.onPressed != null || widget.onLongPressed != null;
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
    widget.onHighlightChanged(true);

    _callbackTimer?.cancel();
    _tapDownTime = _nowTime;
  }

  void _handleTapCancel() {
    if (!_buttonHeldDown) {
      return;
    }

    void handle() {
      _buttonHeldDown = false;
      widget.onHighlightChanged(false);
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
      widget.onHighlightChanged(false);
      if (widget.onPressed != null) {
        widget.onPressed();
      }
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
      textStyle: widget.textStyle,
      animationDuration: _kAnimationDuration,
      child: InkWell(
        onTapDown: _enabled ? _handleTapDown : null,
        onTapCancel: _enabled ? _handleTapCancel : null,
        onTap: _enabled ? _handleTap : null,
        onLongPress: widget.onLongPressed,
        splashColor: widget.splashColor,
        highlightColor: Colors.transparent,
        splashFactory: StoneInkRipple.splashFactory,
        customBorder: widget.splashShape,
        child: widget.child,
      ),
    );
  }
}

/// Cupertino 风格的按钮
class _CupertinoButton extends StatefulWidget {
  const _CupertinoButton({
    this.onPressed,
    this.onLongPressed,
    this.onHighlightChanged,
    this.textStyle,
    this.pressedOpacity,
    this.child,
  });

  /// 按钮被按下的回调
  final VoidCallback onPressed;
  /// 按钮被长按的回调
  final VoidCallback onLongPressed;
  /// 高亮状态改变后的回调
  final ValueChanged<bool> onHighlightChanged;

  /// 文本样式
  final TextStyle textStyle;
  /// 按下后的透明度
  final double pressedOpacity;

  /// 子组件
  final Widget child;

  @override
  __CupertinoButtonState createState() => __CupertinoButtonState();
}

class __CupertinoButtonState extends State<_CupertinoButton> with TickerProviderStateMixin {
  bool get _enabled => widget.onPressed != null || widget.onLongPressed != null;
  bool _buttonHeldDown = false;

  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);
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
    _setTween();
  }

  @override
  void didUpdateWidget(_CupertinoButton old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  void _handleTapDown(TapDownDetails event) {
    if (_buttonHeldDown) {
      return;
    }

    _buttonHeldDown = true;
    _animate();
    widget.onHighlightChanged(true);

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
      widget.onHighlightChanged(false);
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
      widget.onHighlightChanged(false);
      if (widget.onPressed != null) {
        widget.onPressed();
      }
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
      behavior: HitTestBehavior.translucent,
      onTapDown: _enabled ? _handleTapDown : null,
      onTapCancel: _enabled ? _handleTapCancel : null,
      onTap: _enabled ? _handleTap : null,
      onLongPress: widget.onLongPressed,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: AnimatedDefaultTextStyle(
          duration: _kAnimationDuration,
          style: widget.textStyle,
          child: widget.child,
        ),
      ),
    );
  }
}

/// 确保 [child] 满足最小点击区域要求
class _InputPadding extends SingleChildRenderObjectWidget {
  const _InputPadding({
    Key key,
    Widget child,
    this.minSize,
  }) : super(key: key, child: child);

  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputPadding(minSize);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderInputPadding renderObject) {
    renderObject.minSize = minSize;
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, [RenderBox child]) : super(child);

  Size get minSize => _minSize;
  Size _minSize;

  set minSize(Size value) {
    if (_minSize == value) return;
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null) return math.max(child.getMinIntrinsicWidth(height), minSize.width);
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null) return math.max(child.getMinIntrinsicHeight(width), minSize.height);
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null) return math.max(child.getMaxIntrinsicWidth(height), minSize.width);
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null) return math.max(child.getMaxIntrinsicHeight(width), minSize.height);
    return 0.0;
  }

  @override
  void performLayout() {
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);

      final double height = math.max(child.size.width, minSize.width);
      final double width = math.max(child.size.height, minSize.height);
      size = constraints.constrain(Size(height, width));
      final BoxParentData childParentData = child.parentData;
      childParentData.offset = Alignment.center.alongOffset(size - child.size);
    } else {
      size = Size.zero;
    }
  }

  @override
  bool hitTest(HitTestResult result, {Offset position}) {
    return super.hitTest(result, position: position) || child.hitTest(result, position: child.size.center(Offset.zero));
  }
}

/// StoneButton 内部组件，实现可动画的背景色、阴影、形状
class _ButtonInterior extends ImplicitlyAnimatedWidget {
  const _ButtonInterior({
    this.color,
    this.gradient,
    this.background,
    this.elevation,
    this.shadowColor,
    this.shape,
    Curve curve,
    Duration animationDuration,
    this.child,
  }) : super(curve: curve, duration: animationDuration);

  final Color color;
  final Gradient gradient;
  final Widget background;
  final double elevation;
  final Color shadowColor;
  final ShapeBorder shape;
  final Widget child;

  @override
  __ButtonInteriorState createState() => __ButtonInteriorState();
}

class __ButtonInteriorState extends AnimatedWidgetBaseState<_ButtonInterior> {
  ColorTween _color;
  Tween<double> _elevation;
  ColorTween _shadowColor;
  ShapeBorderTween _border;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color = widget.color == null ? null : visitor(_color, widget.color, (dynamic value) => ColorTween(begin: value));
    _elevation = visitor(_elevation, widget.elevation, (dynamic value) => Tween<double>(begin: value));
    _shadowColor = visitor(_shadowColor, widget.shadowColor, (dynamic value) => ColorTween(begin: value));
    _border = visitor(_border, widget.shape, (dynamic value) => ShapeBorderTween(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    final ShapeBorder shape = _border.evaluate(animation);

    final content = AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: _kAnimationDuration,
      decoration: BoxDecoration(
        color: _color?.evaluate(animation),
        gradient: widget.gradient,
      ),
      child: widget.child,
    );

    return PhysicalShape(
      child: _ShapeBorderPaint(
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            if (widget.background != null) Positioned.fill(child: widget.background),
            content,
          ],
        ),
        shape: shape,
      ),
      clipper: ShapeBorderClipper(
        shape: shape,
        textDirection: Directionality.of(context),
      ),
      elevation: _elevation.evaluate(animation),
      color: Colors.transparent,
      shadowColor: _shadowColor.evaluate(animation),
    );
  }
}

class _ShapeBorderPaint extends StatelessWidget {
  const _ShapeBorderPaint({
    @required this.child,
    @required this.shape,
  });

  final Widget child;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(shape: shape),
      child: CustomPaint(
        child: child,
        foregroundPainter: _ShapeBorderPainter(shape, Directionality.of(context)),
      ),
    );
  }
}

class _ShapeBorderPainter extends CustomPainter {
  const _ShapeBorderPainter(this.border, this.textDirection);

  final ShapeBorder border;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    border.paint(canvas, Offset.zero & size, textDirection: textDirection);
  }

  @override
  bool shouldRepaint(_ShapeBorderPainter oldDelegate) {
    return oldDelegate.border != border;
  }
}

/// [StoneButton] 的主题
///
/// 可以一次定义多种按钮样式，在使用 [StoneButton] 时通过 [StoneButton.styleKey] 指定样式。
///
/// {@tool sample}
///
/// ```dart
/// StoneButtonTheme(
///   styles: <String, StoneButtonStyle>{
///     'flat': StoneButtonStyle(),
///     'raised': StoneButtonStyle(),
///     'outline': StoneButtonStyle(),
///     'icon': StoneButtonStyle(),
///   },
///   child: child,
/// )
/// ```
/// {@end-tool}
class StoneButtonTheme extends InheritedWidget {
  StoneButtonTheme({
    Key key,
    Map<String, StoneButtonStyle> styles,
    Widget child,
  }) : data = StoneButtonThemeData(styles: styles), super(key: key, child: child);

  const StoneButtonTheme.fromButtonThemeData({
    Key key,
    @required this.data,
    Widget child,
  })  : assert(data != null), super(key: key, child: child);

  final StoneButtonThemeData data;

  static StoneButtonThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoneButtonTheme>()?.data;
  }

  @override
  bool updateShouldNotify(StoneButtonTheme oldWidget) => data != oldWidget.data;
}

/// StoneButton 主题数据
class StoneButtonThemeData {
  const StoneButtonThemeData({this.styles});

  final Map<String, StoneButtonStyle> styles;

  StoneButtonThemeData copyWidth({Map<String, StoneButtonStyle> styles}) {
    if (styles == null) {
      final newEntries = this.styles.entries.map((entry) => MapEntry<String, StoneButtonStyle>(entry.key, entry.value.copyWidth()));
      final newStyles = Map<String, StoneButtonStyle>.fromEntries(newEntries);
      return StoneButtonThemeData(styles: newStyles);
    }

    return StoneButtonThemeData(styles: styles);
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final StoneButtonThemeData typedOther = other;
    return styles == typedOther.styles;
  }
}

/// [StoneButton] 的样式
class StoneButtonStyle {
  const StoneButtonStyle({
    this.key,
    this.type,
    this.textStyle,
    this.highlightTextStyle,
    this.disabledTextStyle,
    this.color,
    this.highlightColor,
    this.disabledColor,
    this.gradient,
    this.highlightGradient,
    this.disabledGradient,
    this.borderSide,
    this.highlightBorderSide,
    this.disabledBorderSide,
    this.borderRadius,
    this.highlightBorderRadius,
    this.disabledBorderRadius,
    this.background,
    this.highlightBackground,
    this.disabledBackground,
    this.elevation,
    this.highlightElevation,
    this.disabledElevation,
    this.shape,
    this.highlightShape,
    this.disabledShape,
    this.splashColor,
    this.splashShape,
    this.pressedOpacity,
    this.padding,
    this.width,
    this.height,
    this.constraints,
    this.tapTargetSize,
  })  : assert(color == null || gradient == null, 'color 与 gradient 不能同时使用'),
        assert(highlightColor == null || highlightGradient == null, 'highlightColor 与 highlightGradient 不能同时使用'),
        assert(disabledColor == null || disabledGradient == null, 'disabledColor 与 disabledGradient 不能同时使用'),
        assert(borderSide == null || shape == null, 'borderSide 与 shape 不能同时使用'),
        assert(highlightBorderSide == null || highlightShape == null, 'highlightBorderSide 与 highlightShape 不能同时使用'),
        assert(disabledBorderSide == null || disabledShape == null, 'disabledBorderSide 与 disabledShape 不能同时使用'),
        assert(pressedOpacity == null || (pressedOpacity >= 0.1 && pressedOpacity <= 1.0), 'pressedOpacity 的取值为 0.1~1.0');

  StoneButtonStyle copyWidth({
    String key,
    StoneButtonType type,
    TextStyle textStyle,
    TextStyle highlightTextStyle,
    TextStyle disabledTextStyle,
    Color color,
    Color highlightColor,
    Color disabledColor,
    Gradient gradient,
    Gradient highlightGradient,
    Gradient disabledGradient,
    BorderSide borderSide,
    BorderSide highlightBorderSide,
    BorderSide disabledBorderSide,
    BorderRadius borderRadius,
    BorderRadius highlightBorderRadius,
    BorderRadius disabledBorderRadius,
    Widget background,
    Widget highlightBackground,
    Widget disabledBackground,
    double elevation,
    double highlightElevation,
    double disabledElevation,
    ShapeBorder shape,
    ShapeBorder highlightShape,
    ShapeBorder disabledShape,
    Color splashColor,
    ShapeBorder splashBorder,
    double pressedOpacity,
    EdgeInsetsGeometry padding,
    double width,
    double height,
    BoxConstraints constraints,
    Size tapTargetSize,
  }) {
    return StoneButtonStyle(
      key: key ?? this.key,
      type: type ?? this.type,
      textStyle: textStyle ?? this.textStyle,
      highlightTextStyle: highlightTextStyle ?? this.highlightTextStyle,
      disabledTextStyle: disabledTextStyle ?? this.disabledTextStyle,
      color: color ?? this.color,
      highlightColor: highlightColor ?? this.highlightColor,
      disabledColor: disabledColor ?? this.disabledColor,
      gradient: gradient ?? this.gradient,
      highlightGradient: highlightGradient ?? this.highlightGradient,
      disabledGradient: disabledGradient ?? this.disabledGradient,
      borderSide: borderSide ?? this.borderSide,
      highlightBorderSide: highlightBorderSide ?? this.highlightBorderSide,
      disabledBorderSide: disabledBorderSide ?? this.disabledBorderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      highlightBorderRadius: highlightBorderRadius ?? this.highlightBorderRadius,
      disabledBorderRadius: disabledBorderRadius ?? disabledBorderRadius,
      background: background ?? this.background,
      highlightBackground: highlightBackground ?? this.highlightBackground,
      disabledBackground: disabledBackground ?? this.disabledBackground,
      elevation: elevation ?? this.elevation,
      highlightElevation: highlightElevation ?? this.highlightElevation,
      disabledElevation: disabledElevation ?? this.disabledElevation,
      shape: shape ?? this.shape,
      splashColor: splashColor ?? this.splashColor,
      splashShape: splashShape ?? this.splashShape,
      pressedOpacity: pressedOpacity ?? this.pressedOpacity,
      highlightShape: highlightShape ?? this.highlightShape,
      disabledShape: disabledShape ?? this.disabledShape,
      padding: padding ?? this.padding,
      width: width ?? this.width,
      height: height ?? this.height,
      constraints: constraints ?? this.constraints,
      tapTargetSize: tapTargetSize ?? this.tapTargetSize,
    );
  }

  /// 当前样式在 [StoneButtonTheme.styles] 中的 Key
  final String key;
  /// 按钮类型，默认跟随平台
  final StoneButtonType type;

  /// 正常状态下的文本样式
  final TextStyle textStyle;
  /// 高亮状态下的文本样式
  final TextStyle highlightTextStyle;
  /// 禁用状态下的文本样式
  final TextStyle disabledTextStyle;

  /// 正常状态下填充颜色
  final Color color;
  /// 高亮状态下的填充颜色
  final Color highlightColor;
  /// 禁用状态下的填充颜色
  final Color disabledColor;

  /// 正常状态下渐变填充
  final Gradient gradient;
  /// 高亮状态下的渐变填充
  final Gradient highlightGradient;
  /// 禁用状态下的渐变填充
  final Gradient disabledGradient;

  /// 正常状态下边框
  final BorderSide borderSide;
  /// 高亮状态下的边框
  final BorderSide highlightBorderSide;
  /// 禁用状态下的边框
  final BorderSide disabledBorderSide;

  /// 正常状态下边框圆角
  final BorderRadius borderRadius;
  /// 高亮状态下的边框圆角
  final BorderRadius highlightBorderRadius;
  /// 禁用状态下的边框圆角
  final BorderRadius disabledBorderRadius;

  /// 正常状态下背景
  final Widget background;
  /// 高亮状态下的背景
  final Widget highlightBackground;
  /// 禁用状态下的背景
  final Widget disabledBackground;

  /// 正常状态下的阴影半径
  final double elevation;
  /// 高亮状态下的阴影半径
  final double highlightElevation;
  /// 禁用状态下的阴影半径
  final double disabledElevation;

  /// 正常状态下的形状
  final ShapeBorder shape;
  /// 高亮状态下的形状
  final ShapeBorder highlightShape;
  /// 高亮状态下的形状
  final ShapeBorder disabledShape;

  /// splash 颜色，作用于 [StoneButtonType.material] 风格的按钮
  final Color splashColor;
  /// splash 形状，作用于 [StoneButtonType.material] 风格的按钮
  final ShapeBorder splashShape;

  /// 按下后的不透明度，作用于 [StoneButtonType.cupertino] 风格的按钮
  ///
  /// 当 [highlightColor] 或 [highlightGradient] 或 [highlightBackground] 不为 null 时，[pressedOpacity] 将被忽略。
  final double pressedOpacity;

  /// 内边距
  final EdgeInsetsGeometry padding;
  /// 固定宽度
  final double width;
  /// 固定高度
  final double height;

  /// 尺寸约束
  final BoxConstraints constraints;
  /// 最小点击区域
  final Size tapTargetSize;

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final StoneButtonStyle typedOther = other;
    return key == typedOther.key &&
        type == typedOther.type &&
        textStyle == typedOther.textStyle &&
        highlightTextStyle == typedOther.highlightTextStyle &&
        disabledTextStyle == typedOther.disabledTextStyle &&
        color == typedOther.color &&
        highlightColor == typedOther.highlightColor &&
        disabledColor == typedOther.disabledColor &&
        gradient == typedOther.gradient &&
        highlightGradient == typedOther.highlightGradient &&
        disabledGradient == typedOther.disabledGradient &&
        borderSide == typedOther.borderSide &&
        highlightBorderSide == typedOther.highlightBorderSide &&
        disabledBorderSide == typedOther.disabledBorderSide &&
        borderRadius == typedOther.borderRadius &&
        highlightBorderRadius == typedOther.highlightBorderRadius &&
        disabledBorderRadius == typedOther.disabledBorderRadius &&
        background == typedOther.background &&
        highlightBackground == typedOther.highlightBackground &&
        disabledBackground == typedOther.disabledBackground &&
        elevation == typedOther.elevation &&
        highlightElevation == typedOther.highlightElevation &&
        disabledElevation == typedOther.disabledElevation &&
        shape == typedOther.shape &&
        highlightShape == typedOther.highlightShape &&
        disabledShape == typedOther.disabledShape &&
        splashColor == typedOther.splashColor &&
        splashShape == typedOther.splashShape &&
        pressedOpacity == typedOther.pressedOpacity &&
        padding == typedOther.padding &&
        width == typedOther.width &&
        height == typedOther.height &&
        constraints == typedOther.constraints &&
        tapTargetSize == typedOther.tapTargetSize;
  }
}