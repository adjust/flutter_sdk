import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:flutter/services.dart';

enum AdjustLogLevel { VERBOSE, DEBUG, INFO, WARN, ERROR, ASSERT, SUPRESS }

enum AdjustEnvironment { production, sandbox }

typedef void SessionSuccessHandler(AdjustSessionSuccess successData);
typedef void SessionFailureHandler(AdjustSessionFailure failureData);
typedef void EventSuccessHandler(AdjustEventSuccess successData);
typedef void EventFailureHandler(AdjustEventFailure failureData);
typedef void AttributionChangedHandler(AdjustAttribution attributionData);
typedef bool ShouldLaunchReceivedDeeplinkHandler(String uri);
typedef void ReceivedDeeplinkHandler(String uri);

class AdjustConfig {
  static const MethodChannel _channel = const MethodChannel('com.adjust/api');

  String _sdkPrefix = 'flutter4.16.0';
  String appToken;
  String userAgent;
  String defaultTracker;

  bool _callbackHandlersInitialized = false;

  SessionSuccessHandler _sessionSuccessHandler;
  SessionFailureHandler _sessionFailureHandler;
  EventSuccessHandler _eventSuccessHandler;
  EventFailureHandler _eventFailureHandler;
  AttributionChangedHandler _attributionChangedHandler;
  ReceivedDeeplinkHandler _receivedDeeplinkHandler;

  bool _sessionSuccessHandlerImplemented = false;
  bool _sessionFailureHandlerImplemented = false;
  bool _eventSuccessHandlerImplemented = false;
  bool _eventFailureHandlerImplemented = false;
  bool _attributionChangedHandlerImplemented = false;
  bool _receivedDeeplinkHandlerImplemented = false;

  bool isDeviceKnown;
  bool sendInBackground;
  bool eventBufferingEnabled;
  bool allowSuppressLogLevel;
  bool launchDeferredDeeplink;

  AdjustLogLevel logLevel;
  AdjustEnvironment environment;

  num _info1;
  num _info2;
  num _info3;
  num _info4;
  num _secretId;

  double delayStart;

  // Android specific members
  String processName;
  
  AdjustConfig(this.appToken, this.environment);

  String get environmentString {
    return environment
        .toString()
        .substring(environment.toString().indexOf('.') + 1);
  }

  String get logLevelString {
    return logLevel.toString().substring(logLevel.toString().indexOf('.') + 1);
  }

  void setAppSecret(num secretId, num info1, num info2, num info3, num info4) {
    _secretId = secretId;
    _info1 = info1;
    _info2 = info2;
    _info3 = info3;
    _info4 = info4;
  }

  void setSessionSuccessHandler(SessionSuccessHandler handler) {
    _initCallbackHandlers();
    _sessionSuccessHandler = handler;
    _sessionSuccessHandlerImplemented = true;
  }

  void setSessionFailureHandler(SessionFailureHandler handler) {
    _initCallbackHandlers();
    _sessionFailureHandler = handler;
    _sessionFailureHandlerImplemented = true;
  }

  void setEventSuccessHandler(EventSuccessHandler handler) {
    _initCallbackHandlers();
    _eventSuccessHandler = handler;
    _eventSuccessHandlerImplemented = true;
  }

  void setEventFailureHandler(EventFailureHandler handler) {
    _initCallbackHandlers();
    _eventFailureHandler = handler;
    _eventFailureHandlerImplemented = true;
  }

  void setAttributionChangedHandler(AttributionChangedHandler handler) {
    _initCallbackHandlers();
    _attributionChangedHandler = handler;
    _attributionChangedHandlerImplemented = true;
  }

  void setReceivedDeeplinkHandler(ReceivedDeeplinkHandler handler) {
    _initCallbackHandlers();
    _receivedDeeplinkHandler = handler;
    _receivedDeeplinkHandlerImplemented = true;
  }

  void _initCallbackHandlers() {
    if (_callbackHandlersInitialized) {
      return;
    }
    _callbackHandlersInitialized = true;

    _channel.setMethodCallHandler((MethodCall call) {
      print(' >>>>> INCOMING METHOD CALL FROM NATIVE: ${call.method}');

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

  Map<String, String> get configParamsMap {
    Map<String, String> configParamsMap = {
      'sdkPrefix': _sdkPrefix,
      'appToken': appToken,
      'environment': environmentString,
    };

    if (userAgent != null) {
      configParamsMap['userAgent'] = userAgent;
    }
    if (logLevelString != null) {
      configParamsMap['logLevel'] = logLevelString;
    }
    if (defaultTracker != null) {
      configParamsMap['defaultTracker'] = defaultTracker;
    }
    if (isDeviceKnown != null) {
      configParamsMap['isDeviceKnown'] = isDeviceKnown.toString();
    }
    if (sendInBackground != null) {
      configParamsMap['sendInBackground'] = sendInBackground.toString();
    }
    if (eventBufferingEnabled != null) {
      configParamsMap['eventBufferingEnabled'] = eventBufferingEnabled.toString();
    }
    if (allowSuppressLogLevel != null) {
      configParamsMap['allowSuppressLogLevel'] = allowSuppressLogLevel.toString();
    }
    if (launchDeferredDeeplink != null) {
      configParamsMap['launchDeferredDeeplink'] = launchDeferredDeeplink.toString();
    }
    if (_info1 != null) {
      configParamsMap['info1'] = _info1.toString();
    }
    if (_info2 != null) {
      configParamsMap['info2'] = _info2.toString();
    }
    if (_info3 != null) {
      configParamsMap['info3'] = _info3.toString();
    }
    if (_info4 != null) {
      configParamsMap['info4'] = _info4.toString();
    }
    if (_secretId != null) {
      configParamsMap['secretId'] = _secretId.toString();
    }
    if (delayStart != null) {
      configParamsMap['delayStart'] = delayStart.toString();
    }

    configParamsMap['sessionSuccessHandlerImplemented'] = _sessionSuccessHandlerImplemented.toString();
    configParamsMap['sessionFailureHandlerImplemented'] = _sessionFailureHandlerImplemented.toString();
    configParamsMap['eventSuccessHandlerImplemented'] = _eventSuccessHandlerImplemented.toString();
    configParamsMap['eventFailureHandlerImplemented'] = _eventFailureHandlerImplemented.toString();
    configParamsMap['attributionChangedHandlerImplemented'] = _attributionChangedHandlerImplemented.toString();
    configParamsMap['receivedDeeplinkHandlerImplemented'] = _receivedDeeplinkHandlerImplemented.toString();
    
    return configParamsMap;
  }
}
