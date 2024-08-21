//
//  adjust_config.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

import 'dart:convert';

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
typedef void SkanUpdatedCallback(Map<String, String> skanUpdateData);

class AdjustConfig {
  static const MethodChannel _channel =
      const MethodChannel('com.adjust.sdk/api');
  static const String _attributionCallbackName = 'adj-attribution-changed';
  static const String _sessionSuccessCallbackName = 'adj-session-success';
  static const String _sessionFailureCallbackName = 'adj-session-failure';
  static const String _eventSuccessCallbackName = 'adj-event-success';
  static const String _eventFailureCallbackName = 'adj-event-failure';
  static const String _deferredDeeplinkCallbackName = 'adj-deferred-deeplink';
  static const String _skanUpdatedCallbackName = 'adj-skan-updated';

  final String _appToken;
  final AdjustEnvironment _environment;

  bool? isSkanAttributionEnabled;
  bool? isSendingInBackgroundEnabled;
  bool? isAdServicesEnabled;
  bool? isIdfaReadingEnabled;
  bool? isIdfvReadingEnabled;
  bool? isCostDataInAttributionEnabled;
  bool? isPreinstallTrackingEnabled;
  bool? isLinkMeEnabled;
  bool? isDeviceIdsReadingOnceEnabled;
  bool? isCoppaComplianceEnabled;
  bool? isPlayStoreKidsComplianceEnabled;
  bool? isDeferredDeeplinkOpeningEnabled;

  num? attConsentWaitingInterval;
  num? eventDeduplicationIdsMaxSize;

  String? sdkPrefix;
  String? defaultTracker;
  String? externalDeviceId;
  String? processName;
  String? preinstallFilePath;
  String? fbAppId;

  bool? _isDataResidency;
  bool? _useSubdomains;
  List<String> _urlStrategyDomains = [];

  AdjustLogLevel? logLevel;
  AttributionCallback? attributionCallback;
  SessionSuccessCallback? sessionSuccessCallback;
  SessionFailureCallback? sessionFailureCallback;
  EventSuccessCallback? eventSuccessCallback;
  EventFailureCallback? eventFailureCallback;
  DeferredDeeplinkCallback? deferredDeeplinkCallback;
  SkanUpdatedCallback? skanUpdatedCallback;

  AdjustConfig(this._appToken, this._environment) {
    _initCallbackHandlers();
  }

  void setUrlStrategy(List<String> urlStrategyDomains, bool useSubdomains, bool isDataResidency) {
    _urlStrategyDomains.addAll(urlStrategyDomains);
    _useSubdomains = useSubdomains;
    _isDataResidency = isDataResidency;
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
            if (deferredDeeplinkCallback != null) {
              String? uri = call.arguments['uri'];
              if (deferredDeeplinkCallback != null) {
                deferredDeeplinkCallback!(uri);
              }
            }
            break;
          case _skanUpdatedCallbackName:
            if (skanUpdatedCallback != null) {
              skanUpdatedCallback!(Map<String, String>.from(call.arguments));
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
    if (_urlStrategyDomains.isEmpty != true ) {
      configMap['urlStrategyDomains'] = json.encode(_urlStrategyDomains);
    }
    if (_isDataResidency != null) {
      configMap['isDataResidency'] = _isDataResidency.toString();
    }
    if (_useSubdomains != null) {
      configMap['useSubdomains'] = _useSubdomains.toString();
    }
    if (isCostDataInAttributionEnabled != null) {
      configMap['isCostDataInAttributionEnabled'] = isCostDataInAttributionEnabled.toString();
    }
    if (isSendingInBackgroundEnabled != null) {
      configMap['isSendingInBackgroundEnabled'] = isSendingInBackgroundEnabled.toString();
    }
    if (isCostDataInAttributionEnabled != null) {
      configMap['isCostDataInAttributionEnabled'] = isCostDataInAttributionEnabled.toString();
    }
    if (isPreinstallTrackingEnabled != null) {
      configMap['isPreinstallTrackingEnabled'] = isPreinstallTrackingEnabled.toString();
    }
    if (isPlayStoreKidsComplianceEnabled != null) {
      configMap['isPlayStoreKidsComplianceEnabled'] = isPlayStoreKidsComplianceEnabled.toString();
    }
    if (isCoppaComplianceEnabled != null) {
      configMap['isCoppaComplianceEnabled'] = isCoppaComplianceEnabled.toString();
    }
    if (isDeviceIdsReadingOnceEnabled != null) {
      configMap['isDeviceIdsReadingOnceEnabled'] = isDeviceIdsReadingOnceEnabled.toString();
    }
    if (isLinkMeEnabled != null) {
      configMap['isLinkMeEnabled'] = isLinkMeEnabled.toString();
    }
    if (isAdServicesEnabled != null) {
      configMap['isAdServicesEnabled'] = isAdServicesEnabled.toString();
    }
    if (isIdfaReadingEnabled != null) {
      configMap['isIdfaReadingEnabled'] = isIdfaReadingEnabled.toString();
    }
    if (isIdfvReadingEnabled != null) {
      configMap['isIdfvReadingEnabled'] = isIdfvReadingEnabled.toString();
    }
    if (isSkanAttributionEnabled != null) {
      configMap['isSkanAttributionEnabled'] = isSkanAttributionEnabled.toString();
    }
    if (isDeferredDeeplinkOpeningEnabled != null) {
      configMap['isDeferredDeeplinkOpeningEnabled'] = isDeferredDeeplinkOpeningEnabled.toString();
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
    if (skanUpdatedCallback != null) {
      configMap['skanUpdatedCallback'] = _skanUpdatedCallbackName;
    }

    return configMap;
  }
}
