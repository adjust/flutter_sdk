//
//  adjust_config.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
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
typedef void ConversionValueUpdatedCallback(num? conversionValue);
typedef void Skad4ConversionValueUpdatedCallback(num? conversionValue, String? coarseValue, bool? lockWindow);

class AdjustConfig {
  static const MethodChannel _channel =
      const MethodChannel('com.adjust.sdk/api');
  static const String _attributionCallbackName = 'adj-attribution-changed';
  static const String _sessionSuccessCallbackName = 'adj-session-success';
  static const String _sessionFailureCallbackName = 'adj-session-failure';
  static const String _eventSuccessCallbackName = 'adj-event-success';
  static const String _eventFailureCallbackName = 'adj-event-failure';
  static const String _deferredDeeplinkCallbackName = 'adj-deferred-deeplink';
  static const String _conversionValueUpdatedCallbackName =
      'adj-conversion-value-updated';
  static const String _skad4ConversionValueUpdatedCallbackName =
      'adj-skad4-conversion-value-updated';

  String _appToken;
  AdjustEnvironment _environment;

  bool? _skAdNetworkHandling;

  num? attConsentWaitingInterval;
  bool? _sendInBackground;
  bool? allowiAdInfoReading;
  bool? _allowAdServicesInfoReading;
  bool? _allowIdfaReading;
  bool? launchDeferredDeeplink;
  bool? _needsCost;
  bool? preinstallTrackingEnabled;
  bool? _linkMeEnabled;
  bool? finalAndroidAttributionEnabled;
  bool? _readDeviceInfoOnceEnabled;
  String? sdkPrefix;
  num? eventDeduplicationIdsMaxSize;
  String? defaultTracker;
  String? externalDeviceId;
  bool? playStoreKidsAppEnabled;
  bool? coppaCompliantEnabled;
  List<String> domains  = [];
  bool? useSubdomains;
  bool? isDataResidency;
  String? processName;
  String? preinstallFilePath;
  String? fbAppId;
  AdjustLogLevel? logLevel;
  AttributionCallback? attributionCallback;
  SessionSuccessCallback? sessionSuccessCallback;
  SessionFailureCallback? sessionFailureCallback;
  EventSuccessCallback? eventSuccessCallback;
  EventFailureCallback? eventFailureCallback;
  DeferredDeeplinkCallback? deferredDeeplinkCallback;
  ConversionValueUpdatedCallback? conversionValueUpdatedCallback;
  Skad4ConversionValueUpdatedCallback? skad4ConversionValueUpdatedCallback;

  AdjustConfig(this._appToken, this._environment) {
    _initCallbackHandlers();
    _skAdNetworkHandling = true;
  }

  void setUrlStrategy(List<String> _domains, bool _useSubdomains, bool _isDataResidency){
    domains.addAll(_domains);
    useSubdomains = _useSubdomains;
    isDataResidency = _isDataResidency;
  }

  void enableCostDataInAttribution(){
    _needsCost = true;
  }

  void enableSendingInBackground(){
    _sendInBackground = true;
  }

  void disableAdServices(){
    _allowAdServicesInfoReading = false;
  }

  void disableIdfaReading(){
    _allowIdfaReading = false;
  }

  void enableLinkMe(){
    _linkMeEnabled = true;
  }

  void enableDeviceIdsReadingOnce(){
    _readDeviceInfoOnceEnabled = true;
  }

  void _initCallbackHandlers() {
    _channel.setMethodCallHandler((MethodCall call) async {
      try {
        switch (call.method) {
          case _attributionCallbackName:
            if (attributionCallback != null) {
              AdjustAttribution attribution =
                  AdjustAttribution.fromMap(call.arguments);
              attributionCallback!(attribution);
            }
            break;
          case _sessionSuccessCallbackName:
            if (sessionSuccessCallback != null) {
              AdjustSessionSuccess sessionSuccess =
                  AdjustSessionSuccess.fromMap(call.arguments);
              sessionSuccessCallback!(sessionSuccess);
            }
            break;
          case _sessionFailureCallbackName:
            if (sessionFailureCallback != null) {
              AdjustSessionFailure sessionFailure =
                  AdjustSessionFailure.fromMap(call.arguments);
              sessionFailureCallback!(sessionFailure);
            }
            break;
          case _eventSuccessCallbackName:
            if (eventSuccessCallback != null) {
              AdjustEventSuccess eventSuccess =
                  AdjustEventSuccess.fromMap(call.arguments);
              eventSuccessCallback!(eventSuccess);
            }
            break;
          case _eventFailureCallbackName:
            if (eventFailureCallback != null) {
              AdjustEventFailure eventFailure =
                  AdjustEventFailure.fromMap(call.arguments);
              eventFailureCallback!(eventFailure);
            }
            break;
          case _deferredDeeplinkCallbackName:
            if (deferredDeeplinkCallback != null) {
              String? uri = call.arguments['uri'];
              if (deferredDeeplinkCallback != null) {
                deferredDeeplinkCallback!(uri);
              }
            }
            break;
          case _conversionValueUpdatedCallbackName:
            if (conversionValueUpdatedCallback != null) {
              String? conversionValue = call.arguments['conversionValue'];
              if (conversionValue != null) {
                conversionValueUpdatedCallback!(int.parse(conversionValue));
              }
            }
            break;
          case _skad4ConversionValueUpdatedCallbackName:
            if (skad4ConversionValueUpdatedCallback != null) {
              String? conversionValue = call.arguments['fineValue'];
              String? coarseValue = call.arguments['coarseValue'];
              String? lockWindow = call.arguments['lockWindow'];
              if (conversionValue != null && coarseValue != null && lockWindow != null) {
                skad4ConversionValueUpdatedCallback!(
                  int.parse(conversionValue),
                  coarseValue,
                  lockWindow.toLowerCase() == 'true');
              }
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

  void disableSkanAttribution() {
    _skAdNetworkHandling = false;
  }

  Map<String, String?> get toMap {
    Map<String, String?> configMap = {
      'sdkPrefix': sdkPrefix,
      'appToken': _appToken,
      'environment': _environment
          .toString()
          .substring(_environment.toString().indexOf('.') + 1),
    };

    if (processName != null) {
      configMap['processName'] = processName;
    }
    if (logLevel != null) {
      configMap['logLevel'] =
          logLevel.toString().substring(logLevel.toString().indexOf('.') + 1);
    }
    if (defaultTracker != null) {
      configMap['defaultTracker'] = defaultTracker;
    }
    if (externalDeviceId != null) {
      configMap['externalDeviceId'] = externalDeviceId;
    }
    if (eventDeduplicationIdsMaxSize != null) {
      configMap['eventDeduplicationIdsMaxSize'] = eventDeduplicationIdsMaxSize.toString();
    }
    if (preinstallFilePath != null) {
      configMap['preinstallFilePath'] = preinstallFilePath;
    }
    if (fbAppId != null) {
      configMap['fbAppId'] = fbAppId;
    }
    if (domains.isEmpty != true ) {
      configMap['domains'] = domains.toString();
    }

    if (isDataResidency != null) {
      configMap['isDataResidency'] = isDataResidency.toString();
    }
    if (useSubdomains != null) {
      configMap['useSubdomains'] = useSubdomains.toString();
    }
    if (_needsCost != null) {
      configMap['needsCost'] = _needsCost.toString();
    }

    if (_sendInBackground != null) {
      configMap['sendInBackground'] = _sendInBackground.toString();
    }
    if (_needsCost != null) {
      configMap['needsCost'] = _needsCost.toString();
    }
    if (preinstallTrackingEnabled != null) {
      configMap['preinstallTrackingEnabled'] =
          preinstallTrackingEnabled.toString();
    }
    if (playStoreKidsAppEnabled != null) {
      configMap['playStoreKidsAppEnabled'] = playStoreKidsAppEnabled.toString();
    }
    if (coppaCompliantEnabled != null) {
      configMap['coppaCompliantEnabled'] = coppaCompliantEnabled.toString();
    }
    if (finalAndroidAttributionEnabled != null) {
      configMap['finalAndroidAttributionEnabled'] = finalAndroidAttributionEnabled.toString();
    }
    if (_readDeviceInfoOnceEnabled != null) {
      configMap['readDeviceInfoOnceEnabled'] = _readDeviceInfoOnceEnabled.toString();
    }
    if (_linkMeEnabled != null) {
      configMap['linkMeEnabled'] = _linkMeEnabled.toString();
    }
    if (allowiAdInfoReading != null) {
      configMap['allowiAdInfoReading'] = allowiAdInfoReading.toString();
    }
    if (_allowAdServicesInfoReading != null) {
      configMap['allowAdServicesInfoReading'] =
          _allowAdServicesInfoReading.toString();
    }
    if (_allowIdfaReading != null) {
      configMap['allowIdfaReading'] = _allowIdfaReading.toString();
    }
    if (_skAdNetworkHandling != null) {
      configMap['skAdNetworkHandling'] = _skAdNetworkHandling.toString();
    }
    if (launchDeferredDeeplink != null) {
      configMap['launchDeferredDeeplink'] = launchDeferredDeeplink.toString();
    }
    if (attConsentWaitingInterval != null) {
      configMap['attConsentWaitingInterval'] = attConsentWaitingInterval.toString();
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
    if (conversionValueUpdatedCallback != null) {
      configMap['conversionValueUpdatedCallback'] =
          _conversionValueUpdatedCallbackName;
    }
    if (skad4ConversionValueUpdatedCallback != null) {
      configMap['skad4ConversionValueUpdatedCallback'] =
          _skad4ConversionValueUpdatedCallbackName;
    }

    return configMap;
  }
}
