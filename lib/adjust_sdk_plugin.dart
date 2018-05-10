import 'dart:async';

import 'package:adjust_sdk_plugin/adjustConfig.dart';
import 'package:adjust_sdk_plugin/adjustEvent.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjustAttribution.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjustEventFailure.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjustEventSuccess.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjustSessionFailure.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjustSessionSuccess.dart';
import 'package:flutter/services.dart';

typedef void SessionSuccessHandler(AdjustSessionSuccess successData);
typedef void SessionFailureHandler(AdjustSessionFailure failureData);
typedef void EventSuccessHandler(AdjustEventSuccess successData);
typedef void EventFailureHandler(AdjustEventFailure failureData);
typedef void AttributionChangedHandler(AdjustAttribution attributionData);
typedef bool ShouldLaunchReceivedDeeplinkHandler(String uri);

class AdjustSdkPlugin {
  static const MethodChannel _channel = const MethodChannel('com.adjust/api');
  // any disadvantages of using multiple channels ??
  static const MethodChannel _deeplinkChannel =
      const MethodChannel('com.adjust/deeplink');
  static bool _callbackHandlersInitialized = false;

  static SessionSuccessHandler _sessionSuccessHandler;
  static SessionFailureHandler _sessionFailureHandler;
  static EventSuccessHandler _eventSuccessHandler;
  static EventFailureHandler _eventFailureHandler;
  static AttributionChangedHandler _attributionChangedHandler;
  static ShouldLaunchReceivedDeeplinkHandler
      _shouldLaunchReceivedDeeplinkHandler;

  static void _initCallbackHandlers() {
    if (_callbackHandlersInitialized) {
      return;
    }
    _callbackHandlersInitialized = true;

    // set deeplink channel handler
    _deeplinkChannel.setMethodCallHandler(_deeplinkChannelHandler);

    _channel.setMethodCallHandler((MethodCall call) {
      print(" >>>>> INCOMING METHOD FROM NATIVE: " + call.method);

      try {
        switch (call.method) {
          case 'session-success':
            AdjustSessionSuccess sessionSuccess =
                AdjustSessionSuccess.fromMap(call.arguments);
            if (_sessionSuccessHandler != null)
              _sessionSuccessHandler(sessionSuccess);
            break;
          case 'session-fail':
            AdjustSessionFailure sessionFailure =
                AdjustSessionFailure.fromMap(call.arguments);
            if (_sessionFailureHandler != null)
              _sessionFailureHandler(sessionFailure);
            break;
          case 'event-success':
            AdjustEventSuccess eventSuccess =
                AdjustEventSuccess.fromMap(call.arguments);
            if (_eventSuccessHandler != null)
              _eventSuccessHandler(eventSuccess);
            break;
          case 'event-fail':
            AdjustEventFailure eventFailure =
                AdjustEventFailure.fromMap(call.arguments);
            if (_eventFailureHandler != null)
              _eventFailureHandler(eventFailure);
            break;
          case 'attribution-change':
            AdjustAttribution attribution =
                AdjustAttribution.fromMap(call.arguments);
            if (_attributionChangedHandler != null)
              _attributionChangedHandler(attribution);
            break;
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  static Future<dynamic> _deeplinkChannelHandler(MethodCall call) async {
    print(" >>>>> INCOMING DEEPLINK METHOD FROM NATIVE: " + call.method);

    switch (call.method) {
      case 'should-launch-uri':
        String uri = call.arguments['uri'];
        if (_shouldLaunchReceivedDeeplinkHandler != null) {
          return _shouldLaunchReceivedDeeplinkHandler(uri);
        }
        // TODO: what to return in case the client did not implement '_shouldLaunchReceivedDeeplinkHandler'
        return false;
      default:
        throw new UnsupportedError('Unknown method: ${call.method}');
    }
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

  static void setAttributionChangedHandler(AttributionChangedHandler handler) {
    _initCallbackHandlers();
    _attributionChangedHandler = handler;
  }

  static void setShouldLaunchReceivedDeeplinkHandler(
      ShouldLaunchReceivedDeeplinkHandler handler) {
    _initCallbackHandlers();
    _shouldLaunchReceivedDeeplinkHandler = handler;
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

  static void setOfflineMode(bool isOffline) {
    _channel.invokeMethod('setOfflineMode', {'isOffline': isOffline});
  }

  static void setPushToken(String token) {
    _channel.invokeMethod('setPushToken', {'token': token});
  }

  static void appWillOpenUrl(String url) {
    _channel.invokeMethod('appWillOpenUrl', {'url': url});
  }

  static void sendFirstPackages() {
    _channel.invokeMethod('sendFirstPackages');
  }

  static Future<String> getAdid() async {
    final String adid = await _channel.invokeMethod('getAdid');
    return adid;
  }

  static Future<String> getIdfa() async {
    final String idfa = await _channel.invokeMethod('getIdfa');
    return idfa;
  }

  static Future<String> getAmazonAdId() async {
    final String amazonAdId = await _channel.invokeMethod('getAmazonAdId');
    return amazonAdId;
  }

  static void setReferrer(String referrer) {
    _channel.invokeMethod('setReferrer', {'referrer': referrer});
  }

  static Future<String> getGoogleAdId() async {
    final String googleAdId = await _channel.invokeMethod('getGoogleAdId');
    return googleAdId;
  }

  static Future<AdjustAttribution> getAttribution() async {
    final Map attributionMap = await _channel.invokeMethod('getAttribution');
    return AdjustAttribution.fromMap(attributionMap);
  }

  static void addSessionCallbackParameter(String key, String value) {
    _channel.invokeMethod(
        'addSessionCallbackParameter', {'key': key, 'value': value});
  }

  static void addSessionPartnerParameter(String key, String value) {
    _channel.invokeMethod(
        'addSessionPartnerParameter', {'key': key, 'value': value});
  }

  static void removeSessionCallbackParameter(String key) {
    _channel.invokeMethod('removeSessionCallbackParameter', {'key': key});
  }

  static void removeSessionPartnerParameter(String key) {
    _channel.invokeMethod('removeSessionPartnerParameter', {'key': key});
  }

  static void resetSessionCallbackParameters() {
    _channel.invokeMethod('resetSessionCallbackParameters');
  }

  static void resetSessionPartnerParameters() {
    _channel.invokeMethod('resetSessionPartnerParameters');
  }
}
