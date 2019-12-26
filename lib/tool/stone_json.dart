import 'dart:convert';

/// JSON 节点
///
/// 提供 "null 值安全" + "类型安全" 的 JSON 操作
class StoneJson {
  /// 从一个 [Map] 或 [List] 构建 JSON 节点
  StoneJson(this.rawData);

  /// 从一个 JSON 字符串构建 JSON 节点
  factory StoneJson.decode(String source) {
    try {
      return StoneJson(json.decode(source));
    } catch (_) {
      return StoneJson(null);
    }
  }

  /// 当前节点的原始数据
  final dynamic rawData;

  /// 当前节点是否为 [Map]
  bool get isMap => rawData is Map;
  /// 当前节点是否为 [List]
  bool get isList => rawData is List;

  /// 当前节点是否为空，[rawData] 为 'null、empty、类型错误时' 返回 true
  bool get isEmpty {
    if (rawData is Map) {
      return rawData.isEmpty;
    }
    if (rawData is List) {
      return rawData.isEmpty;
    }
    return true;
  }

  /// 当前节点是否不为空
  bool get isNotEmpty => !isEmpty;

  /// 获取 [num] 值，值不存在默认返回 0，当值为 [String] 类型时尝试转换
  double numValue([num defaultValue = 0]) {
    if (rawData is num) {
      return rawData;
    }
    if (rawData is String) {
      return num.tryParse(rawData) ?? defaultValue;
    }
    return defaultValue;
  }

  /// 获取 [int] 值，值不存在默认返回 0，当值为 [num] 或 [String] 类型时进行转换
  int intValue([int defaultValue = 0]) {
    if (rawData is num) {
      return rawData.toInt();
    }
    if (rawData is String) {
      return num.tryParse(rawData)?.toInt() ?? defaultValue;
    }
    return defaultValue;
  }

  /// 获取 [double] 值，值不存在默认返回 0.0，当值为 [num] 或 [String] 类型时进行转换
  double doubleValue([double defaultValue = 0.0]) {
    if (rawData is num) {
      return rawData.toDouble();
    }
    if (rawData is String) {
      return num.tryParse(rawData)?.toDouble() ?? defaultValue;
    }
    return defaultValue;
  }

  /// 获取 [bool] 值，值不存在默认返回 false，当值为 [num] 或 [String] 类型时进行转换
  bool boolValue([bool defaultValue = false]) {
    if (rawData is bool) {
      return rawData;
    }
    if (rawData is num) {
      return rawData != 0;
    }
    if (rawData is String) {
      final str = rawData.toLowerCase();
      return str == 'true' || str == 'yes' || str != '0';
    }
    return defaultValue;
  }

  /// 获取 [String] 值，值不存在默认返回 ''，当前值为 [num] 或 [bool] 时进行转换
  String stringValue([String defaultValue = '']) {
    if (rawData is String || rawData is num || rawData is bool) {
      return rawData.toString();
    }
    return defaultValue;
  }

  /// 将当前节点转换为 [Map<String, StoneJson>]
  Map<String, StoneJson> mapValue([Map defaultValue = const <String, StoneJson>{}]) =>
      rawData is Map
          ? Map.fromEntries(rawData.map( (key, value) => MapEntry(key, StoneJson(value))))
          : defaultValue;

  /// 将当前节点转换为 [List<StoneJson>]
  List<StoneJson> listValue([List defaultValue = const <StoneJson>[]]) =>
      isList ? rawData.map<StoneJson>((e) => StoneJson(e)).toList() : <StoneJson>[];

  /// 通过下标方式获取值
  ///
  /// {@tool sample}
  ///
  /// ```dart
  /// StoneJson.decode(jsonString)['toys'][0]['color'].stringValue('No Color')
  /// ```
  /// {@end-tool}
  StoneJson operator [](Object index) =>
      ((index is int && isList) || (index is String && isMap))
          ? StoneJson(rawData[index]) : StoneJson(null);
}