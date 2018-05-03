import 'dart:async';

import 'package:adjust_sdk_plugin/adjustConfig.dart';
import 'package:adjust_sdk_plugin/adjustEvent.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjustEventFailure.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjustEventSuccess.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjustSessionFailure.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjustSessionSuccess.dart';
import 'package:flutter/services.dart';

typedef void SessionSuccessHandler(AdjustSessionSuccess successData);
typedef void SessionFailureHandler(AdjustSessionFailure failureData);
typedef void EventSuccessHandler(AdjustEventSuccess successData);
typedef void EventFailureHandler(AdjustEventFailure failureData);

class AdjustSdkPlugin {
  static const MethodChannel _channel =
      const MethodChannel('adjust_sdk_plugin');
  static bool _callbackHandlersInitialized = false;

  static SessionSuccessHandler _sessionSuccessHandler;
  static SessionFailureHandler _sessionFailureHandler;
  static EventSuccessHandler _eventSuccessHandler;
  static EventFailureHandler _eventFailureHandler;

  static void _initCallbackHandlers() {
    if (_callbackHandlersInitialized) {
      return;
    }
    _callbackHandlersInitialized = true;

    _channel.setMethodCallHandler((MethodCall call) {
      print(" !!!!!! INCOMING METHOD FROM NATIVE: " + call.method);
      
      switch (call.method) {
        case 'session-success':
          AdjustSessionSuccess sessionSuccess =
              AdjustSessionSuccess.fromMap(call.arguments);
          _sessionSuccessHandler(sessionSuccess);
          break;
        case 'session-fail':
          AdjustSessionFailure sessionFailure =
              AdjustSessionFailure.fromMap(call.arguments);
          _sessionFailureHandler(sessionFailure);
          break;
        case 'event-success':
          AdjustEventSuccess eventSuccess =
              AdjustEventSuccess.fromMap(call.arguments);
          _eventSuccessHandler(eventSuccess);
          break;
        case 'event-fail':
          AdjustEventFailure eventFailure =
              AdjustEventFailure.fromMap(call.arguments);
          _eventFailureHandler(eventFailure);
          break;
      }
    });
  }

  static void setSessionSuccessHandler(SessionSuccessHandler handler) {
    _initCallbackHandlers();
    _sessionSuccessHandler = handler;
  }

  static void setSessionFailureHandler(SessionFailureHandler handler) {
    _initCallbackHandlers();
    _sessionFailureHandler = handler;
  }

  static void setEventSuccessHandler(EventSuccessHandler handler) {
    _initCallbackHandlers();
    _eventSuccessHandler = handler;
  }

  static void setEventFailureHandler(EventFailureHandler handler) {
    _initCallbackHandlers();
    _eventFailureHandler = handler;
  }

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
    _initCallbackHandlers();
    _channel.invokeMethod('onCreate', config.configParamsMap);
  }

  static void trackEvent(AdjustEvent adjustEvent) {
    _channel.invokeMethod('trackEvent', adjustEvent.adjustEventParamsMap);
  }

  static void addSessionCallbackParameter(String key, String value) {
    _channel.invokeMethod(
        'addSessionCallbackParameter', {'key': key, 'value': value});
  }

  static void addSessionPartnerParameter(String key, String value) {
    _channel.invokeMethod(
        'addSessionPartnerParameter', {'key': key, 'value': value});
  }
}
