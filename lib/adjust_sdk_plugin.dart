import 'dart:async';

import 'package:adjust_sdk_plugin/adjustConfig.dart';
import 'package:adjust_sdk_plugin/adjustEvent.dart';
import 'package:flutter/services.dart';

class AdjustSdkPlugin {
  static const MethodChannel _channel =
      const MethodChannel('adjust_sdk_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void onResume() {
    print('Calling "ON RESUME" from flutter...');
    _channel.invokeMethod('onResume');
  }

  static void onPause() {
    print('Calling "ON PAUSE" from flutter...');
    _channel.invokeMethod('onPause');
  }

  static Future<bool> isEnabled() async {
    final bool isEnabled = await _channel.invokeMethod('isEnabled');
    return isEnabled;
  }

  static void setIsEnabled(bool isEnabled) {
    _channel.invokeMethod('setIsEnabled', {'isEnabled': isEnabled});
  }

  static void onCreate(AdjustConfig config) {
    _channel.invokeMethod('onCreate', config.configParamsMap);
  }

  static void trackEvent(AdjustEvent adjustEvent) {
    _channel.invokeMethod('trackEvent', adjustEvent.adjustEventParamsMap);
  }
}
