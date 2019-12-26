import 'package:flutter/material.dart';
import 'package:stone_flutter_kit/stone_flutter_kit.dart';

import 'colors.dart';
import 'styles.dart';

/// App 主题
class AppThemeDatas {
  static ThemeData light = ThemeData.light().copyWith(
    primaryColor: AppColors.primary,
    accentColor: AppColors.accent,
    scaffoldBackgroundColor: AppColors.pageBackground,
    indicatorColor: AppColors.indicatorColor,
    splashColor: AppColors.splashColor,
    cursorColor: AppColors.cursorColor,
    textSelectionColor: AppColors.textSelectionColor,
    textSelectionHandleColor: AppColors.textSelectionHandleColor,
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: AppColors.barBackground,
      elevation: 1.0,
      iconTheme: IconThemeData(size: 20.0),
      textTheme: TextTheme(
        title: TextStyle(color: AppColors.black, fontSize: 20.0, fontWeight: FontWeight.w500),
        button: TextStyle(color: AppColors.black, fontSize: 15.0, fontWeight: FontWeight.w400),
      ),
    ),
  );
}

/// App 中常用的按钮主题
class AppButtonThemes {
  static StoneButtonTheme light({Widget child}) => StoneButtonTheme(
    styles: <String, StoneButtonStyle>{
      AppButtonStyles.redStadiumRaised.key: AppButtonStyles.redStadiumRaised,
      AppButtonStyles.greyStadiumRaised.key: AppButtonStyles.greyStadiumRaised,
      AppButtonStyles.whiteStadiumRaised.key: AppButtonStyles.whiteStadiumRaised,
    },
    child: child,
  );
}