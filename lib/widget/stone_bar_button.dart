import 'package:flutter/material.dart';
import 'package:stone_flutter_kit/widget/stone_button.dart';

/// 用于导航栏的返回按钮
///
/// 注意：当 [StoneBackButton] 作为 [AppBar.leading] 时，宽度被限定为 56。
class StoneBackButton extends StatelessWidget {
  const StoneBackButton({
    Key key,
    this.onPressed,
    this.type,
    this.icon = const Icon(Icons.arrow_back_ios),
    this.title = const Text('返回'),
    this.splashColor,
  }) : assert(icon != null || title != null), super(key: key);

  /// 点击后的回调
  ///
  /// 不为 null 时需要在 [onPressed] 中手动管理页面栈。
  final VoidCallback onPressed;

  /// 按钮类型，默认跟随平台
  final StoneButtonType type;
  /// 按钮图标
  final Widget icon;
  /// splash 颜色
  final Color splashColor;
  /// 按钮标题
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return StoneBarButton(
      onPressed: () => onPressed != null ? onPressed() : Navigator.maybePop(context),
      type: type,
      icon: icon,
      title: title,
      splashColor: splashColor,
      spacing: 0.0,
      padding: EdgeInsets.zero,
    );
  }
}

/// 用在 Toolbar、NavigationBar 中的按钮
class StoneBarButton extends StatelessWidget {
  const StoneBarButton({
    Key key,
    this.onPressed,
    this.type,
    this.icon,
    this.title,
    this.splashColor,
    this.spacing = 0.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : assert(icon != null || title != null), super(key: key);

  /// 点击后的回调
  final VoidCallback onPressed;

  /// 按钮类型，默认跟随平台
  final StoneButtonType type;
  /// 按钮图标
  final Widget icon;
  /// 按钮标题
  final Widget title;
  /// splash 颜色
  final Color splashColor;
  /// 图标与标题的间隔
  final double spacing;
  /// 按钮内边距
  final EdgeInsets padding;
  /// 按钮内容横向对齐方式
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    return Theme(
      data: ThemeData(
        textTheme: TextTheme(
          button: appBarTheme.textTheme.button,
        ),
        iconTheme: appBarTheme.iconTheme,
      ),
      child: StoneButton(
        onPressed: onPressed,
        type: type,
        splashColor: splashColor,
        splashShape: CircleBorder(),
        padding: padding,
        tapTargetSize: Size(46.0, 46.0),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: <Widget>[
            if (icon != null) icon,
            if (icon != null && title != null) SizedBox(width: spacing),
            if (title != null) title,
          ],
        ),
      ),
    );
  }
}