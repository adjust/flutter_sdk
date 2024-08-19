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

  String _appToken;
  AdjustEnvironment _environment;

  bool? _isSkanAttributionEnabled;
  bool? _isSendingInBackgroundEnabled;
  bool? _isAdServicesEnabled;
  bool? _isIdfaReadingEnabled;
  bool? _isIdfvReadingEnabled;
  bool? _isCostDataInAttributionEnabled;
  bool? _isPreinstallTrackingEnabled;
  bool? _isLinkMeEnabled;
  bool? _isDeviceIdsReadingOnceEnabled;
  bool? isCoppaComplianceEnabled;
  bool? isPlayStoreKidsComplianceEnabled;
  bool? isDeferredDeeplinkOpeningEnabled;
  bool? shouldUseSubdomains;
  bool? isDataResidency;

  num? attConsentWaitingInterval;
  num? eventDeduplicationIdsMaxSize;

  String? sdkPrefix;
  String? defaultTracker;
  String? externalDeviceId;
  String? processName;
  String? preinstallFilePath;
  String? fbAppId;

  List<String> urlStrategyDomains = [];

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

  void enableCostDataInAttribution() {
    _isCostDataInAttributionEnabled = true;
  }

  void enableSendingInBackground() {
    _isSendingInBackgroundEnabled = true;
  }

  void disableAdServices() {
    _isAdServicesEnabled = false;
  }

  void disableIdfaReading() {
    _isIdfaReadingEnabled = false;
  }

  void disableIdfvReading() {
    _isIdfvReadingEnabled = false;
  }

  void enableLinkMe() {
    _isLinkMeEnabled = true;
  }

  void enableDeviceIdsReadingOnce() {
    _isDeviceIdsReadingOnceEnabled = true;
  }

  void disableSkanAttribution() {
    _isSkanAttributionEnabled = false;
  }

  void setUrlStrategy(List<String> _urlStrategyDomains, bool _shouldUseSubdomains, bool _isDataResidency) {
    urlStrategyDomains.addAll(_urlStrategyDomains);
    shouldUseSubdomains = _shouldUseSubdomains;
    isDataResidency = _isDataResidency;
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
    if (urlStrategyDomains.isEmpty != true ) {
      configMap['urlStrategyDomains'] = urlStrategyDomains.toString();
    }
    if (isDataResidency != null) {
      configMap['isDataResidency'] = isDataResidency.toString();
    }
    if (shouldUseSubdomains != null) {
      configMap['shouldUseSubdomains'] = shouldUseSubdomains.toString();
    }
    if (_isCostDataInAttributionEnabled != null) {
      configMap['isCostDataInAttributionEnabled'] = _isCostDataInAttributionEnabled.toString();
    }
    if (_isSendingInBackgroundEnabled != null) {
      configMap['isSendingInBackgroundEnabled'] = _isSendingInBackgroundEnabled.toString();
    }
    if (_isCostDataInAttributionEnabled != null) {
      configMap['isCostDataInAttributionEnabled'] = _isCostDataInAttributionEnabled.toString();
    }
    if (_isPreinstallTrackingEnabled != null) {
      configMap['isPreinstallTrackingEnabled'] = _isPreinstallTrackingEnabled.toString();
    }
    if (isPlayStoreKidsComplianceEnabled != null) {
      configMap['isPlayStoreKidsComplianceEnabled'] = isPlayStoreKidsComplianceEnabled.toString();
    }
    if (isCoppaComplianceEnabled != null) {
      configMap['isCoppaComplianceEnabled'] = isCoppaComplianceEnabled.toString();
    }
    if (_isDeviceIdsReadingOnceEnabled != null) {
      configMap['isDeviceIdsReadingOnceEnabled'] = _isDeviceIdsReadingOnceEnabled.toString();
    }
    if (_isLinkMeEnabled != null) {
      configMap['isLinkMeEnabled'] = _isLinkMeEnabled.toString();
    }
    if (_isAdServicesEnabled != null) {
      configMap['isAdServicesEnabled'] = _isAdServicesEnabled.toString();
    }
    if (_isIdfaReadingEnabled != null) {
      configMap['isIdfaReadingEnabled'] = _isIdfaReadingEnabled.toString();
    }
    if (_isIdfvReadingEnabled != null) {
      configMap['isIdfvReadingEnabled'] = _isIdfvReadingEnabled.toString();
    }
    if (_isSkanAttributionEnabled != null) {
      configMap['isSkanAttributionEnabled'] = _isSkanAttributionEnabled.toString();
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
