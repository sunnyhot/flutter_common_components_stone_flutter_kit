import 'package:intl/intl.dart';

/// 数字格式化器
class StoneNumberFormatter {
  /// 金额格式化器
  static String formatCurrency(num amount, {
    String locale = 'zh_Hans_CN',
    int minimumFractionDigits = 0,
    int maximumFractionDigits = 2,
  }) {
    final formatter = NumberFormat.simpleCurrency(locale: locale);
    formatter.minimumFractionDigits = minimumFractionDigits;
    formatter.maximumFractionDigits = maximumFractionDigits;
    return formatter.format(amount);
  }

  /// 数字格式化器
  static String formatNumber(num number, {
    String locale = 'zh_Hans_CN',
    int minimumFractionDigits = 0,
    int maximumFractionDigits = 2,
  }) {
    final formatter = NumberFormat.currency(locale: locale, symbol: '', customPattern: '###0.###');
    formatter.minimumFractionDigits = minimumFractionDigits;
    formatter.maximumFractionDigits = maximumFractionDigits;
    return formatter.format(number);
  }
}