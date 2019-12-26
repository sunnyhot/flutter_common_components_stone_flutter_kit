library stone_flutter_kit;

import 'dart:async';

import 'package:flutter/services.dart';

export 'extension/stone_list_view.dart';
export 'extension/stone_string.dart';

export 'tool/stone_json.dart';
export 'tool/stone_number_formatter.dart';
export 'tool/stone_text_input_formatter.dart';

export 'widget/stone_async_body.dart';
export 'widget/stone_bar_button.dart';
export 'widget/stone_button.dart';
export 'widget/stone_bottom_toolbar.dart';
export 'widget/stone_counter_builder.dart';
export 'widget/stone_item.dart';
export 'widget/stone_ink_ripple.dart';
export 'widget/stone_tap_gesture_detector.dart';

class StoneFlutterKit {
  static const MethodChannel _channel = const MethodChannel('stone_flutter_kit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}