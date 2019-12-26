import 'package:flutter/material.dart';
import 'package:stone_flutter_kit/stone_flutter_kit.dart';

import 'colors.dart';

/// App 中常用的文本样式
class AppTextStyles {
  // -------------------------- 白色 --------------------------

  /// 细体-白色
  static TextStyle whiteW300({double fontSize}) => TextStyle(
    color: AppColors.white,
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
  );

  /// 常规体-白色
  static TextStyle whiteW400({double fontSize}) => TextStyle(
    color: AppColors.white,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
  );

  /// 中粗体-白色
  static TextStyle whiteW500({double fontSize}) => TextStyle(
    color: AppColors.white,
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );

  /// 半粗体-白色
  static TextStyle whiteW600({double fontSize}) => TextStyle(
    color: AppColors.white,
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
  );

  // -------------------------- 浅灰色 --------------------------

  /// 细体-浅灰色
  static TextStyle lightGreyW300({double fontSize}) => TextStyle(
    color: AppColors.lightGrey,
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
  );

  /// 常规体-浅灰色
  static TextStyle lightGreyW400({double fontSize}) => TextStyle(
    color: AppColors.lightGrey,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
  );

  /// 中粗体-浅灰色
  static TextStyle lightGreyW500({double fontSize}) => TextStyle(
    color: AppColors.lightGrey,
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );

  /// 半粗体-浅灰色
  static TextStyle lightGreyW600({double fontSize}) => TextStyle(
    color: AppColors.lightGrey,
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
  );

  // -------------------------- 灰色 --------------------------

  /// 细体-灰色
  static TextStyle greyW300({double fontSize}) => TextStyle(
    color: AppColors.grey,
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
  );

  /// 常规体-灰色
  static TextStyle greyW400({double fontSize}) => TextStyle(
    color: AppColors.grey,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
  );

  /// 中粗体-灰色
  static TextStyle greyW500({double fontSize}) => TextStyle(
    color: AppColors.grey,
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );

  /// 半粗体-灰色
  static TextStyle greyW600({double fontSize}) => TextStyle(
    color: AppColors.grey,
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
  );

  // -------------------------- 黑色 --------------------------

  /// 细体-黑色
  static TextStyle blackW300({double fontSize}) => TextStyle(
    color: AppColors.black,
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
  );

  /// 常规体-黑色
  static TextStyle blackW400({double fontSize}) => TextStyle(
    color: AppColors.black,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
  );

  /// 中粗体-黑色
  static TextStyle blackW500({double fontSize}) => TextStyle(
    color: AppColors.black,
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );

  /// 半粗体-黑色
  static TextStyle blackW600({double fontSize}) => TextStyle(
    color: AppColors.black,
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
  );

  // -------------------------- 红色 --------------------------

  /// 细体-红色
  static TextStyle redW300({double fontSize}) => TextStyle(
    color: AppColors.red,
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
  );

  /// 常规体-红色
  static TextStyle redW400({double fontSize}) => TextStyle(
    color: AppColors.red,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
  );

  /// 中粗体-红色
  static TextStyle redW500({double fontSize}) => TextStyle(
    color: AppColors.red,
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );

  /// 半粗体-红色
  static TextStyle redW600({double fontSize}) => TextStyle(
    color: AppColors.red,
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
  );
}

/// App 中常用的按钮样式
class AppButtonStyles {
  /// 红色-圆角-实心
  static const StoneButtonStyle redStadiumRaised = StoneButtonStyle(
    key: 'redStadiumRaised',
    textStyle: TextStyle(color: AppColors.white, fontSize: 15.0, fontWeight: FontWeight.w400),
    disabledColor: Colors.green,
    gradient: LinearGradient(colors: AppColors.redGradient),
    shape: StadiumBorder(),
    splashColor: AppColors.splashColor,
  );

  /// 灰色-圆角-实心
  static StoneButtonStyle greyStadiumRaised = StoneButtonStyle(
    key: 'greyStadiumRaised',
    textStyle: TextStyle(color: AppColors.white, fontSize: 15.0, fontWeight: FontWeight.w400),
    color: Color(0xFF555555),
    shape: StadiumBorder(),
    splashColor: AppColors.splashColor,
  );

  /// 白色-圆角-实心
  static StoneButtonStyle whiteStadiumRaised = StoneButtonStyle(
    key: 'whiteStadiumRaised',
    textStyle: const TextStyle(color: AppColors.red, fontSize: 15.0, fontWeight: FontWeight.w400),
    color: AppColors.white,
    shape: StadiumBorder(side: BorderSide(color: AppColors.red, width: 1.0)),
    splashColor: AppColors.lightRed,
  );
}