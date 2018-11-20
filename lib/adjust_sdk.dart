import 'dart:async';

import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/callbacksData/adjust_attribution.dart';
import 'package:adjust_sdk/callbacksData/adjust_event_failure.dart';
import 'package:adjust_sdk/callbacksData/adjust_event_success.dart';
import 'package:adjust_sdk/callbacksData/adjust_session_failure.dart';
import 'package:adjust_sdk/callbacksData/adjust_session_success.dart';
import 'package:flutter/services.dart';

typedef void SessionSuccessHandler(AdjustSessionSuccess successData);
typedef void SessionFailureHandler(AdjustSessionFailure failureData);
typedef void EventSuccessHandler(AdjustEventSuccess successData);
typedef void EventFailureHandler(AdjustEventFailure failureData);
typedef void AttributionChangedHandler(AdjustAttribution attributionData);
typedef bool ShouldLaunchReceivedDeeplinkHandler(String uri);
typedef void ReceivedDeeplinkHandler(String uri);

class Adjust {
  static const MethodChannel _channel = const MethodChannel('com.adjust/api');

  static bool _callbackHandlersInitialized = false;

  static SessionSuccessHandler _sessionSuccessHandler;
  static SessionFailureHandler _sessionFailureHandler;
  static EventSuccessHandler _eventSuccessHandler;
  static EventFailureHandler _eventFailureHandler;
  static AttributionChangedHandler _attributionChangedHandler;
  static ReceivedDeeplinkHandler _receivedDeeplinkHandler;

  static void _initCallbackHandlers() {
    if (_callbackHandlersInitialized) {
      return;
    }
    _callbackHandlersInitialized = true;

    _channel.setMethodCallHandler((MethodCall call) {
      print(" >>>>> INCOMING METHOD CALL FROM NATIVE: ${call.method}");

      try {
        switch (call.method) {
          case 'receive-deferred-deeplink':
            String uri = call.arguments['uri'];
            print(' >>>>> Received deferred deeplink: $uri');
            if (_receivedDeeplinkHandler != null) {
              _receivedDeeplinkHandler(uri);
            }
            break;
          case 'session-success':
            if (_sessionSuccessHandler != null) {
              AdjustSessionSuccess sessionSuccess =
                  AdjustSessionSuccess.fromMap(call.arguments);
              _sessionSuccessHandler(sessionSuccess);
            }
            break;
          case 'session-fail':
            if (_sessionFailureHandler != null) {
              AdjustSessionFailure sessionFailure =
                  AdjustSessionFailure.fromMap(call.arguments);
              _sessionFailureHandler(sessionFailure);
            }
            break;
          case 'event-success':
            if (_eventSuccessHandler != null) {
              AdjustEventSuccess eventSuccess =
                  AdjustEventSuccess.fromMap(call.arguments);
              _eventSuccessHandler(eventSuccess);
            }
            break;
          case 'event-fail':
            if (_eventFailureHandler != null) {
              AdjustEventFailure eventFailure =
                  AdjustEventFailure.fromMap(call.arguments);
              _eventFailureHandler(eventFailure);
            }
            break;
          case 'attribution-change':
            if (_attributionChangedHandler != null) {
              AdjustAttribution attribution =
                  AdjustAttribution.fromMap(call.arguments);
              _attributionChangedHandler(attribution);
            }
            break;
          default:
            throw new UnsupportedError('Unknown method: ${call.method}');
        }
      } catch (e) {
        print(e.toString());
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

  static void setAttributionChangedHandler(AttributionChangedHandler handler) {
    _initCallbackHandlers();
    _attributionChangedHandler = handler;
  }

  static void setReceivedDeeplinkHandler(ReceivedDeeplinkHandler handler) {
    _initCallbackHandlers();
    _receivedDeeplinkHandler = handler;
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

  static void gdprForgetMe() {
    _channel.invokeMethod('gdprForgetMe');
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

  // for integration testing only
  static void setTestOptions(final dynamic testOptions) {
    _channel.invokeMethod('setTestOptions', testOptions);
  }
}
