//
//  adjust_config.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-2021 Adjust GmbH. All rights reserved.
//

import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:flutter/services.dart';

enum AdjustLogLevel { verbose, debug, info, warn, error, suppress }
enum AdjustEnvironment { production, sandbox }

typedef void AttributionCallback(AdjustAttribution attributionData);
typedef void SessionSuccessCallback(AdjustSessionSuccess successData);
typedef void SessionFailureCallback(AdjustSessionFailure failureData);
typedef void EventSuccessCallback(AdjustEventSuccess successData);
typedef void EventFailureCallback(AdjustEventFailure failureData);
typedef void DeferredDeeplinkCallback(String? uri);

class AdjustConfig {
  static const MethodChannel _channel = const MethodChannel('com.adjust.sdk/api');
  static const String _attributionCallbackName = 'adj-attribution-changed';
  static const String _sessionSuccessCallbackName = 'adj-session-success';
  static const String _sessionFailureCallbackName = 'adj-session-failure';
  static const String _eventSuccessCallbackName = 'adj-event-success';
  static const String _eventFailureCallbackName = 'adj-event-failure';
  static const String _deferredDeeplinkCallbackName = 'adj-deferred-deeplink';
  static const String UrlStrategyIndia = 'india';
  static const String UrlStrategyChina = 'china';
  static const String AdRevenueSourceMopub = 'mopub';
  static const String AdRevenueSourceAdmob = 'admob';
  static const String AdRevenueSourceFbNativeAd = 'facebook_native_ad';
  static const String AdRevenueSourceFbAudienceNetwork = 'facebook_audience_network';
  static const String AdRevenueSourceIronsource = 'ironsource';
  static const String AdRevenueSourceFyber = 'fyber';
  static const String AdRevenueSourceAerserv = 'aerserv';
  static const String AdRevenueSourceAppodeal = 'appodeal';
  static const String AdRevenueSourceAdincube = 'adincube';
  static const String AdRevenueSourceFusePowered = 'fusepowered';
  static const String AdRevenueSourceAddaptr = 'addapptr';
  static const String AdRevenueSourceMillenialMediation = 'millennial_mediation';
  static const String AdRevenueSourceFlurry = 'flurry';
  static const String AdRevenueSourceAdmost = 'admost';
  static const String AdRevenueSourceDeltadna = 'deltadna';
  static const String AdRevenueSourceUpsight = 'upsight';
  static const String AdRevenueSourceUnityAds = 'unityads';
  static const String AdRevenueSourceAdtoapp = 'adtoapp';
  static const String AdRevenueSourceTapdaq = 'tapdaq';

  num? _info1;
  num? _info2;
  num? _info3;
  num? _info4;
  num? _secretId;
  String _appToken;
  AdjustEnvironment _environment;
  bool? _skAdNetworkHandling;

  double? delayStart;
  bool? isDeviceKnown;
  bool? sendInBackground;
  bool? eventBufferingEnabled;
  bool? allowiAdInfoReading;
  bool? allowAdServicesInfoReading;
  bool? allowIdfaReading;
  bool? launchDeferredDeeplink;
  bool? needsCost;
  bool? preinstallTrackingEnabled;
  String? sdkPrefix;
  String? userAgent;
  String? defaultTracker;
  String? externalDeviceId;
  String? urlStrategy;
  String? processName;
  AdjustLogLevel? logLevel;
  AttributionCallback? attributionCallback;
  SessionSuccessCallback? sessionSuccessCallback;
  SessionFailureCallback? sessionFailureCallback;
  EventSuccessCallback? eventSuccessCallback;
  EventFailureCallback? eventFailureCallback;
  DeferredDeeplinkCallback? deferredDeeplinkCallback;

  AdjustConfig(this._appToken, this._environment) {
    _initCallbackHandlers();
    _skAdNetworkHandling = true;
  }

  void setAppSecret(num secretId, num info1, num info2, num info3, num info4) {
    _secretId = secretId;
    _info1 = info1;
    _info2 = info2;
    _info3 = info3;
    _info4 = info4;
  }

  void deactivateSKAdNetworkHandling() {
    _skAdNetworkHandling = false;
  }

  void _initCallbackHandlers() {
    _channel.setMethodCallHandler((MethodCall call) async {
      try {
        switch (call.method) {
          case _attributionCallbackName:
            if (attributionCallback != null) {
              AdjustAttribution attribution = AdjustAttribution.fromMap(call.arguments);
              attributionCallback!(attribution);
            }
            break;
          case _sessionSuccessCallbackName:
            if (sessionSuccessCallback != null) {
              AdjustSessionSuccess sessionSuccess = AdjustSessionSuccess.fromMap(call.arguments);
              sessionSuccessCallback!(sessionSuccess);
            }
            break;
          case _sessionFailureCallbackName:
            if (sessionFailureCallback != null) {
              AdjustSessionFailure sessionFailure = AdjustSessionFailure.fromMap(call.arguments);
              sessionFailureCallback!(sessionFailure);
            }
            break;
          case _eventSuccessCallbackName:
            if (eventSuccessCallback != null) {
              AdjustEventSuccess eventSuccess = AdjustEventSuccess.fromMap(call.arguments);
              eventSuccessCallback!(eventSuccess);
            }
            break;
          case _eventFailureCallbackName:
            if (eventFailureCallback != null) {
              AdjustEventFailure eventFailure = AdjustEventFailure.fromMap(call.arguments);
              eventFailureCallback!(eventFailure);
            }
            break;
          case _deferredDeeplinkCallbackName:
            String? uri = call.arguments['uri'];
            if (deferredDeeplinkCallback != null) {
              deferredDeeplinkCallback!(uri);
            }
            break;
          default:
            throw new UnsupportedError(
                '[AdjustFlutter]: Received unknown native method: ${call.method}');
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  Map<String, String?> get toMap {
    Map<String, String?> configMap = {
      'sdkPrefix': sdkPrefix,
      'appToken': _appToken,
      'environment': _environment.toString().substring(_environment.toString().indexOf('.') + 1),
    };

    if (userAgent != null) {
      configMap['userAgent'] = userAgent;
    }
    if (processName != null) {
      configMap['processName'] = processName;
    }
    if (logLevel != null) {
      configMap['logLevel'] = logLevel.toString().substring(logLevel.toString().indexOf('.') + 1);
    }
    if (defaultTracker != null) {
      configMap['defaultTracker'] = defaultTracker;
    }
    if (externalDeviceId != null) {
      configMap['externalDeviceId'] = externalDeviceId;
    }
    if (urlStrategy != null) {
      configMap['urlStrategy'] = urlStrategy;
    }
    if (isDeviceKnown != null) {
      configMap['isDeviceKnown'] = isDeviceKnown.toString();
    }
    if (sendInBackground != null) {
      configMap['sendInBackground'] = sendInBackground.toString();
    }
    if (eventBufferingEnabled != null) {
      configMap['eventBufferingEnabled'] = eventBufferingEnabled.toString();
    }
    if (needsCost != null) {
      configMap['needsCost'] = needsCost.toString();
    }
    if (preinstallTrackingEnabled != null) {
      configMap['preinstallTrackingEnabled'] = preinstallTrackingEnabled.toString();
    }
    if (allowiAdInfoReading != null) {
      configMap['allowiAdInfoReading'] = allowiAdInfoReading.toString();
    }
    if (allowAdServicesInfoReading != null) {
      configMap['allowAdServicesInfoReading'] = allowAdServicesInfoReading.toString();
    }
    if (allowIdfaReading != null) {
      configMap['allowIdfaReading'] = allowIdfaReading.toString();
    }
    if (_skAdNetworkHandling != null) {
      configMap['skAdNetworkHandling'] = _skAdNetworkHandling.toString();
    }
    if (launchDeferredDeeplink != null) {
      configMap['launchDeferredDeeplink'] = launchDeferredDeeplink.toString();
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
    if (delayStart != null) {
      configMap['delayStart'] = delayStart.toString();
    }
    if (attributionCallback != null) {
      configMap['attributionCallback'] = _attributionCallbackName;
    }
    if (sessionSuccessCallback != null) {
      configMap['sessionSuccessCallback'] = _sessionSuccessCallbackName;
    }
    if (sessionFailureCallback != null) {
      configMap['sessionFailureCallback'] = _sessionFailureCallbackName;
    }
    if (eventSuccessCallback != null) {
      configMap['eventSuccessCallback'] = _eventSuccessCallbackName;
    }
    if (eventFailureCallback != null) {
      configMap['eventFailureCallback'] = _eventFailureCallbackName;
    }
    if (deferredDeeplinkCallback != null) {
      configMap['deferredDeeplinkCallback'] = _deferredDeeplinkCallbackName;
    }

    return configMap;
  }
}
