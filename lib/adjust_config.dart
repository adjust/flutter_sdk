//
//  adjust_config.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

import 'package:flutter/services.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';

enum AdjustLogLevel { VERBOSE, DEBUG, INFO, WARN, ERROR, ASSERT, SUPPRESS }
enum AdjustEnvironment { PRODUCTION, SANDBOX }

typedef void AttributionCallback(AdjustAttribution attributionData);
typedef void SessionSuccessCallback(AdjustSessionSuccess successData);
typedef void SessionFailureCallback(AdjustSessionFailure failureData);
typedef void EventSuccessCallback(AdjustEventSuccess successData);
typedef void EventFailureCallback(AdjustEventFailure failureData);
typedef void DeferredDeeplinkCallback(String uri);

class AdjustConfig {
  static const MethodChannel _channel = const MethodChannel('com.adjust.sdk/api');

  double _delayStart;
  bool _isDeviceKnown;
  bool _sendInBackground;
  bool _eventBufferingEnabled;
  bool _launchDeferredDeeplink;
  num _info1;
  num _info2;
  num _info3;
  num _info4;
  num _secretId;
  String _appToken;
  String _sdkPrefix;
  String _userAgent;
  String _defaultTracker;
  String _processName;
  AdjustLogLevel _logLevel;
  AdjustEnvironment _environment;
  AttributionCallback _attributionCallback;
  SessionSuccessCallback _sessionSuccessCallback;
  SessionFailureCallback _sessionFailureCallback;
  EventSuccessCallback _eventSuccessCallback;
  EventFailureCallback _eventFailureCallback;
  DeferredDeeplinkCallback _deferredDeeplinkCallback;
  
  AdjustConfig(this._appToken, this._environment) {
    _initCallbackHandlers();
  }

  void setDelayStart(double delayStart) {
    _delayStart = delayStart;
  }

  void setDeviceKnown(bool isDeviceKnown) {
    _isDeviceKnown = isDeviceKnown;
  }

  void setSendInBackground(bool shouldSend) {
    _sendInBackground = shouldSend;
  }

  void setEventBufferingEnabled(bool isEnabled) {
    _eventBufferingEnabled = isEnabled;
  }

  void setLaunchDeferredDeeplink(bool shouldLaunch) {
    _launchDeferredDeeplink = shouldLaunch;
  }

  void setSdkPrefix(String sdkPrefix) {
    _sdkPrefix = sdkPrefix;
  }

  void setUserAgent(String userAgent) {
    _userAgent = userAgent;
  }

  void setDefaultTracker(String defaultTracker) {
    _defaultTracker = defaultTracker;
  }

  void setLogLevel(AdjustLogLevel logLevel) {
    _logLevel = logLevel;
  }

  void setAppSecret(num secretId, num info1, num info2, num info3, num info4) {
    _secretId = secretId;
    _info1 = info1;
    _info2 = info2;
    _info3 = info3;
    _info4 = info4;
  }

  void setAttributionCallback(AttributionCallback callback) {
    _attributionCallback = callback;
  }

  void setSessionSuccessCallback(SessionSuccessCallback callback) {
    _sessionSuccessCallback = callback;
  }

  void setSessionFailureCallback(SessionFailureCallback callback) {
    _sessionFailureCallback = callback;
  }

  void setEventSuccessCallback(EventSuccessCallback callback) {
    _eventSuccessCallback = callback;
  }

  void setEventFailureCallback(EventFailureCallback callback) {
    _eventFailureCallback = callback;
  }

  void setDeferredDeeplinkCallback(DeferredDeeplinkCallback callback) {
    _deferredDeeplinkCallback = callback;
  }

  void _initCallbackHandlers() {
    _channel.setMethodCallHandler((MethodCall call) {
      try {
        switch (call.method) {
          case 'adj-attribution-changed':
            if (_attributionCallback != null) {
              AdjustAttribution attribution = AdjustAttribution.fromMap(call.arguments);
              _attributionCallback(attribution);
            }
            break;
          case 'adj-session-success':
            if (_sessionSuccessCallback != null) {
              AdjustSessionSuccess sessionSuccess = AdjustSessionSuccess.fromMap(call.arguments);
              _sessionSuccessCallback(sessionSuccess);
            }
            break;
          case 'adj-session-failure':
            if (_sessionFailureCallback != null) {
              AdjustSessionFailure sessionFailure = AdjustSessionFailure.fromMap(call.arguments);
              _sessionFailureCallback(sessionFailure);
            }
            break;
          case 'adj-event-success':
            if (_eventSuccessCallback != null) {
              AdjustEventSuccess eventSuccess = AdjustEventSuccess.fromMap(call.arguments);
              _eventSuccessCallback(eventSuccess);
            }
            break;
          case 'adj-event-failure':
            if (_eventFailureCallback != null) {
              AdjustEventFailure eventFailure = AdjustEventFailure.fromMap(call.arguments);
              _eventFailureCallback(eventFailure);
            }
            break;
          case 'adj-deferred-deeplink':
            String uri = call.arguments['uri'];
            if (_deferredDeeplinkCallback != null) {
              _deferredDeeplinkCallback(uri);
            }
            break;
          default:
            throw new UnsupportedError('[AdjustFlutter]: Received unknown native method: ${call.method}');
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  Map<String, String> get toMap {
    Map<String, String> configMap = {
      'sdkPrefix': _sdkPrefix,
      'appToken': _appToken,
      'environment': _environment.toString().toLowerCase().substring(_environment.toString().indexOf('.') + 1),
    };

    if (_userAgent != null) {
      configMap['userAgent'] = _userAgent;
    }
    if (_logLevel != null) {
      configMap['logLevel'] = _logLevel.toString().substring(_logLevel.toString().indexOf('.') + 1);
    }
    if (_defaultTracker != null) {
      configMap['defaultTracker'] = _defaultTracker;
    }
    if (_isDeviceKnown != null) {
      configMap['isDeviceKnown'] = _isDeviceKnown.toString();
    }
    if (_sendInBackground != null) {
      configMap['sendInBackground'] = _sendInBackground.toString();
    }
    if (_eventBufferingEnabled != null) {
      configMap['eventBufferingEnabled'] = _eventBufferingEnabled.toString();
    }
    if (_launchDeferredDeeplink != null) {
      configMap['launchDeferredDeeplink'] = _launchDeferredDeeplink.toString();
    }
    if (_info1 != null) {
      configMap['info1'] = _info1.toString();
    }
    if (_info2 != null) {
      configMap['info2'] = _info2.toString();
    }
    if (_info3 != null) {
      configMap['info3'] = _info3.toString();
    }
    if (_info4 != null) {
      configMap['info4'] = _info4.toString();
    }
    if (_secretId != null) {
      configMap['secretId'] = _secretId.toString();
    }
    if (_delayStart != null) {
      configMap['delayStart'] = _delayStart.toString();
    }
    if (_attributionCallback != null) {
      configMap['attributionCallback'] = 'adj-attribution-changed';
    }
    if (_sessionSuccessCallback != null) {
      configMap['sessionSuccessCallback'] = 'adj-session-success';
    }
    if (_sessionFailureCallback != null) {
      configMap['sessionFailureCallback'] = 'adj-session-failure';
    }
    if (_eventSuccessCallback != null) {
      configMap['eventSuccessCallback'] = 'adj-event-success';
    }
    if (_eventFailureCallback != null) {
      configMap['eventFailureCallback'] = 'adj-event-failure';
    }
    if (_deferredDeeplinkCallback != null) {
      configMap['deferredDeeplinkCallback'] = 'adj-deferred-deeplink';
    }

    return configMap;
  }
}
