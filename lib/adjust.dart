//
//  adjust_sdk.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

import 'dart:async';

import 'package:adjust_sdk/adjust_ad_revenue.dart';
import 'package:adjust_sdk/adjust_app_store_subscription.dart';
import 'package:adjust_sdk/adjust_app_store_purchase.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_play_store_purchase.dart';
import 'package:adjust_sdk/adjust_play_store_subscription.dart';
import 'package:adjust_sdk/adjust_purchase_verification_result.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:adjust_sdk/adjust_third_party_sharing.dart';
import 'package:adjust_sdk/adjust_deeplink.dart';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

typedef void DirectDeeplinkCallback(String? deeplink);

class Adjust {
  static const String _sdkPrefix = 'flutter5.5.1';
  static const MethodChannel _channel =
      const MethodChannel('com.adjust.sdk/api');
  static const String _attributionCallbackName = 'adj-attribution-changed';
  static const String _sessionSuccessCallbackName = 'adj-session-success';
  static const String _sessionFailureCallbackName = 'adj-session-failure';
  static const String _eventSuccessCallbackName = 'adj-event-success';
  static const String _eventFailureCallbackName = 'adj-event-failure';
  static const String _deferredDeeplinkCallbackName = 'adj-deferred-deeplink';
  static const String _directDeeplinkCallbackName = 'adj-direct-deeplink';
  static const String _skanUpdatedCallbackName = 'adj-skan-updated';

  static bool _isMethodCallHandlerInitialized = false;
  static AttributionCallback? _attributionCallback;
  static SessionSuccessCallback? _sessionSuccessCallback;
  static SessionFailureCallback? _sessionFailureCallback;
  static EventSuccessCallback? _eventSuccessCallback;
  static EventFailureCallback? _eventFailureCallback;
  static DeferredDeeplinkCallback? _deferredDeeplinkCallback;
  static SkanUpdatedCallback? _skanUpdatedCallback;
  static DirectDeeplinkCallback? _directDeeplinkCallback;

  static set directDeeplinkCallback(DirectDeeplinkCallback? callback) {
    _directDeeplinkCallback = callback;
  }

  // common

  static void initSdk(AdjustConfig config) {
    _initMethodCallHandler();
    _setSdkCallbacks(config);
    config.sdkPrefix = _sdkPrefix;
    _channel.invokeMethod('initSdk', config.toMap);
  }

  static void _setSdkCallbacks(AdjustConfig config) {
    _attributionCallback = config.attributionCallback;
    _sessionSuccessCallback = config.sessionSuccessCallback;
    _sessionFailureCallback = config.sessionFailureCallback;
    _eventSuccessCallback = config.eventSuccessCallback;
    _eventFailureCallback = config.eventFailureCallback;
    _deferredDeeplinkCallback = config.deferredDeeplinkCallback;
    _skanUpdatedCallback = config.skanUpdatedCallback;
  }

  static void _initMethodCallHandler() {
    if (_isMethodCallHandlerInitialized) {
      return;
    }

    _channel.setMethodCallHandler((MethodCall call) async {
      try {
        switch (call.method) {
          case _attributionCallbackName:
            if (_attributionCallback != null) {
              AdjustAttribution attribution =
                  AdjustAttribution.fromMap(call.arguments);
              _attributionCallback!(attribution);
            }
            break;
          case _sessionSuccessCallbackName:
            if (_sessionSuccessCallback != null) {
              AdjustSessionSuccess sessionSuccess =
                  AdjustSessionSuccess.fromMap(call.arguments);
              _sessionSuccessCallback!(sessionSuccess);
            }
            break;
          case _sessionFailureCallbackName:
            if (_sessionFailureCallback != null) {
              AdjustSessionFailure sessionFailure =
                  AdjustSessionFailure.fromMap(call.arguments);
              _sessionFailureCallback!(sessionFailure);
            }
            break;
          case _eventSuccessCallbackName:
            if (_eventSuccessCallback != null) {
              AdjustEventSuccess eventSuccess =
                  AdjustEventSuccess.fromMap(call.arguments);
              _eventSuccessCallback!(eventSuccess);
            }
            break;
          case _eventFailureCallbackName:
            if (_eventFailureCallback != null) {
              AdjustEventFailure eventFailure =
                  AdjustEventFailure.fromMap(call.arguments);
              _eventFailureCallback!(eventFailure);
            }
            break;
          case _deferredDeeplinkCallbackName:
            if (_deferredDeeplinkCallback != null) {
              String? deeplink = call.arguments['deeplink'];
              _deferredDeeplinkCallback!(deeplink);
            }
            break;
          case _directDeeplinkCallbackName:
            String? deeplink = call.arguments['deeplink'];
            _onDirectDeeplinkReceived(deeplink);
            break;
          case _skanUpdatedCallbackName:
            if (_skanUpdatedCallback != null) {
              _skanUpdatedCallback!(Map<String, String>.from(call.arguments));
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

    _isMethodCallHandlerInitialized = true;
  }

  static void _onDirectDeeplinkReceived(String? deeplink) {
    if (_directDeeplinkCallback != null) {
      _directDeeplinkCallback!(deeplink);
    }
  }

  static void trackEvent(AdjustEvent event) {
    _channel.invokeMethod('trackEvent', event.toMap);
  }

  static void trackAdRevenue(AdjustAdRevenue adRevenue) {
    _channel.invokeMethod('trackAdRevenue', adRevenue.toMap);
  }

  static void trackThirdPartySharing(
      AdjustThirdPartySharing thirdPartySharing) {
    _channel.invokeMethod('trackThirdPartySharing', thirdPartySharing.toMap);
  }

  static void trackMeasurementConsent(bool measurementConsent) {
    _channel.invokeMethod(
        'trackMeasurementConsent', {'measurementConsent': measurementConsent});
  }

  static void processDeeplink(AdjustDeeplink deeplink) {
    _channel.invokeMethod('processDeeplink', deeplink.toMap);
  }

  static Future<String?> processAndResolveDeeplink(AdjustDeeplink deeplink) async {
    final resolvedLink = 
      await _channel.invokeMethod('processAndResolveDeeplink', deeplink.toMap);
    return resolvedLink;
  }

  static void setPushToken(String token) {
    _channel.invokeMethod('setPushToken', {'pushToken': token});
  }

  static void gdprForgetMe() {
    _channel.invokeMethod('gdprForgetMe');
  }

  static void enable() {
    _channel.invokeMethod('enable');
  }

  static void disable() {
    _channel.invokeMethod('disable');
  }

  static void switchToOfflineMode() {
    _channel.invokeMethod('switchToOfflineMode');
  }

  static void switchBackToOnlineMode() {
    _channel.invokeMethod('switchBackToOnlineMode');
  }

  static void addGlobalCallbackParameter(String key, String value) {
    _channel.invokeMethod(
        'addGlobalCallbackParameter', {'key': key, 'value': value});
  }

  static void addGlobalPartnerParameter(String key, String value) {
    _channel.invokeMethod(
        'addGlobalPartnerParameter', {'key': key, 'value': value});
  }

  static void removeGlobalCallbackParameter(String key) {
    _channel.invokeMethod('removeGlobalCallbackParameter', {'key': key});
  }

  static void removeGlobalPartnerParameter(String key) {
    _channel.invokeMethod('removeGlobalPartnerParameter', {'key': key});
  }

  static void removeGlobalCallbackParameters() {
    _channel.invokeMethod('removeGlobalCallbackParameters');
  }

  static void removeGlobalPartnerParameters() {
    _channel.invokeMethod('removeGlobalPartnerParameters');
  }

  static void endFirstSessionDelay() {
    _channel.invokeMethod('endFirstSessionDelay');
  }

  static void enableCoppaComplianceInDelay() {
    _channel.invokeMethod('enableCoppaComplianceInDelay');
  }

  static void disableCoppaComplianceInDelay() {
    _channel.invokeMethod('disableCoppaComplianceInDelay');
  }

  static void setExternalDeviceIdInDelay(String externalDeviceId) {
    _channel.invokeMethod('setExternalDeviceIdInDelay',{'externalDeviceId': externalDeviceId});
  }

  static Future<bool> isEnabled() async {
    final bool isEnabled = await _channel.invokeMethod('isEnabled');
    return isEnabled;
  }

  static Future<String?> getAdid() async {
    final String? adid = await _channel.invokeMethod('getAdid');
    return adid;
  }

  static Future<String?> getAdidWithTimeout(int timeoutInMilliseconds) async {
    final String? adid = await _channel.invokeMethod('getAdidWithTimeout', {'timeoutInMilliseconds': timeoutInMilliseconds});
    return adid;
  }

  static Future<AdjustAttribution> getAttribution() async {
    final dynamic attributionMap =
        await _channel.invokeMethod('getAttribution');
    return AdjustAttribution.fromMap(attributionMap);
  }

  static Future<AdjustAttribution?> getAttributionWithTimeout(int timeoutInMilliseconds) async {
    final dynamic attributionMap =
        await _channel.invokeMethod('getAttributionWithTimeout', {'timeoutInMilliseconds': timeoutInMilliseconds});
    if (attributionMap == null) {
      return null;
    }
    return AdjustAttribution.fromMap(attributionMap);
  }

  static Future<String?> getLastDeeplink() async {
    final String? deeplink = await _channel.invokeMethod('getLastDeeplink');
    return deeplink;
  }

  static Future<String> getSdkVersion() async {
    final String sdkVersion = await _channel.invokeMethod('getSdkVersion');
    return _sdkPrefix + '@' + sdkVersion;
  }

  // ios only

  static void trackAppStoreSubscription(
      AdjustAppStoreSubscription subscription) {
    _channel.invokeMethod('trackAppStoreSubscription', subscription.toMap);
  }

  static Future<AdjustPurchaseVerificationResult?> verifyAppStorePurchase(
    AdjustAppStorePurchase purchase) async {
    final dynamic appStorePurchaseMap = 
      await _channel.invokeMethod('verifyAppStorePurchase', purchase.toMap);
    return AdjustPurchaseVerificationResult.fromMap(appStorePurchaseMap);
  }

  static Future<AdjustPurchaseVerificationResult?> verifyAndTrackAppStorePurchase(
      AdjustEvent event) async {
    final dynamic appStorePurchaseMap =
      await _channel.invokeMethod('verifyAndTrackAppStorePurchase', event.toMap);
    return AdjustPurchaseVerificationResult.fromMap(appStorePurchaseMap);
  }

  static Future<num> requestAppTrackingAuthorization() async {
    final num status = await _channel
        .invokeMethod('requestAppTrackingAuthorization');
    return status;
  }

  static Future<String?> updateSkanConversionValue(int conversionValue, String coarseValue, bool lockWindow) async {
    final String? error = await _channel.invokeMethod('updateSkanConversionValue', {
      'conversionValue': conversionValue,
      'coarseValue': coarseValue,
      'lockWindow': lockWindow
    });
    return error;
  }

  static Future<String?> getIdfa() async {
    final String? idfa = await _channel.invokeMethod('getIdfa');
    return idfa;
  }

  static Future<String?> getIdfv() async {
    final String? idfv = await _channel.invokeMethod('getIdfv');
    return idfv;
  }

  static Future<int> getAppTrackingAuthorizationStatus() async {
    final int authorizationStatus =
        await _channel.invokeMethod('getAppTrackingAuthorizationStatus');
    return authorizationStatus;
  }

  // android only

  static void trackPlayStoreSubscription(
      AdjustPlayStoreSubscription subscription) {
    _channel.invokeMethod('trackPlayStoreSubscription', subscription.toMap);
  }

  static Future<AdjustPurchaseVerificationResult?> verifyPlayStorePurchase(
    AdjustPlayStorePurchase purchase) async {
    final dynamic playStorePurchaseMap = 
      await _channel.invokeMethod('verifyPlayStorePurchase', purchase.toMap);
    return AdjustPurchaseVerificationResult.fromMap(playStorePurchaseMap);
  }

  static Future<AdjustPurchaseVerificationResult?> verifyAndTrackPlayStorePurchase(
      AdjustEvent event) async {
    final dynamic playStorePurchaseMap =
      await _channel.invokeMethod('verifyAndTrackPlayStorePurchase', event.toMap);
    return AdjustPurchaseVerificationResult.fromMap(playStorePurchaseMap);
  }

  static void enablePlayStoreKidsComplianceInDelay() {
    _channel.invokeMethod('enablePlayStoreKidsComplianceInDelay');
  }

  static void disablePlayStoreKidsComplianceInDelay() {
    _channel.invokeMethod('disablePlayStoreKidsComplianceInDelay');
  }

  static Future<String?> getAmazonAdId() async {
    final String? amazonAdId = await _channel.invokeMethod('getAmazonAdId');
    return amazonAdId;
  }

  static Future<String?> getGoogleAdId() async {
    final String? googleAdId = await _channel.invokeMethod('getGoogleAdId');
    return googleAdId;
  }

  // for testing purposes only, do not use in production!

  @visibleForTesting
  static void onResume() {
    _channel.invokeMethod('onResume');
  }

  @visibleForTesting
  static void onPause() {
    _channel.invokeMethod('onPause');
  }

  @visibleForTesting
  static void setTestOptions(final dynamic testOptions) {
    _channel.invokeMethod('setTestOptions', testOptions);
  }
}
