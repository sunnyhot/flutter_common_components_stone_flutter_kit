import 'package:flutter/material.dart';

/// App 中常用的颜色值
class AppColors {
  /// 白色
  static const Color white = Colors.white;
  /// 黑色
  static const Color black = Color(0xFF404040);

  /// 红色
  static const Color red = Color(0xFFFF483D);
  /// 浅红色
  static const Color lightRed = Color(0xFFFBEFEE);

  /// 绿色
  static const Color green = Colors.teal;
  /// 浅绿色
  static const Color lightGreen = Colors.tealAccent;

  /// 红色渐变
  static const List<Color> redGradient = [Color(0xFFE34D44), Color(0xFFFF643F)];
  /// 绿色渐变
  static const List<Color> greenGradient = [green, Colors.green];

  /// 灰色
  static const Color grey = Color(0xFF888888);
  /// 浅灰色
  static const Color lightGrey = Color(0xFFCCCCCC);

  /// 主色
  static const Color primary = white;
  /// 强调色
  static const Color accent = green;
  /// 高亮色
  static const Color highlight = lightGreen;

  /// Splash 颜色
  static const Color splashColor = Color(0x80CCCCCC);
  /// 指示器颜色
  static const Color indicatorColor = green;
  /// hint 颜色
  static const Color hint = lightGrey;
  /// 分割线颜色
  static const Color dividerColor = Color(0xFFD9D9D9);

  /// 光标颜色
  static const Color cursorColor = green;
  /// 文本选中的背景颜色
  static const textSelectionColor = lightRed;
  /// 调整文本选中范围的手柄的颜色
  static const textSelectionHandleColor = green;

  /// 导航栏、工具栏背景色
  static const Color barBackground = white;
  /// 页面背景色
  static const Color pageBackground = Color(0xFFF4F4F4);

  /// 弹窗背景色
  static const Color dialogBackground = white;
  /// 弹窗蒙版颜色
  static const Color dialogMask = Color(0x66000000);
  /// Toast背景色
  static const Color toastBackground = black;
}