import 'package:flutter/material.dart';

/// 页面底部工具栏
class StoneBottomToolbar extends StatelessWidget {
  const StoneBottomToolbar({
    Key key,
    this.padding,
    this.height,
    this.color,
    this.decoration,
    this.child,
  }) : assert(color == null || decoration == null, 'color 与 decoration 不能同时使用'), super(key: key);

  /// 高度
  final double height;
  /// 内边距
  final EdgeInsets padding;
  /// 背景色
  final Color color;
  /// 装饰
  final Decoration decoration;
  /// 内容部件
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeData = StoneBottomToolbarTheme.of(context);
    final barPadding = (padding ?? themeData?.padding) ?? EdgeInsets.zero;
    final barHeight = height ?? themeData?.height;
    final barColor = (color ?? themeData?.color) ?? Colors.white;
    final barDecoration = decoration ?? themeData?.decoration;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      alignment: Alignment.center,
      padding: barPadding + EdgeInsets.only(bottom: bottomInset),
      height: barHeight == null ? null : barHeight + bottomInset,
      decoration: barDecoration ?? BoxDecoration(color: barColor),
      child: child,
    );
  }
}

/// [StoneBottomToolbar] 主题
class StoneBottomToolbarTheme extends InheritedWidget {
  const StoneBottomToolbarTheme({
    Key key,
    StoneBottomToolbarThemeData data,
    Widget child,
  }) : data = data, super(key: key, child: child);

  const StoneBottomToolbarTheme.fromButtonThemeData({
    Key key,
    @required this.data,
    Widget child,
  }) : assert(data != null), super(key: key, child: child);

  final StoneBottomToolbarThemeData data;

  static StoneBottomToolbarThemeData of(BuildContext context) {
    final StoneBottomToolbarTheme inheritedButtonTheme = context.inheritFromWidgetOfExactType(StoneBottomToolbarTheme);
    return inheritedButtonTheme?.data;
  }

  @override
  bool updateShouldNotify(StoneBottomToolbarTheme oldWidget) => data != oldWidget.data;
}

/// [StoneBottomToolbar] 主题数据
class StoneBottomToolbarThemeData {
  const StoneBottomToolbarThemeData({
    this.padding,
    this.height,
    this.color,
    this.decoration
  }) : assert(color == null || decoration == null, 'color 与 decoration 不能同时使用');

  StoneBottomToolbarThemeData copyWidth({
    EdgeInsets padding,
    double height,
    Color color,
    Decoration decoration,
  }) => StoneBottomToolbarThemeData(
    padding: padding ?? this.padding,
    height: height ?? this.height,
    color: color ?? this.color,
    decoration: decoration ?? this.decoration,
  );

  /// 内边距
  final EdgeInsets padding;
  /// 高度
  final double height;
  /// 背景色
  final Color color;
  /// 装饰
  final Decoration decoration;

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

    final StoneBottomToolbarThemeData typedOther = other;
    return padding == typedOther.padding
        && height == typedOther.height
        && color == typedOther.color
        && decoration == typedOther.decoration;
  }
}