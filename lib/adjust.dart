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
import 'package:adjust_sdk/adjust_play_store_purchase.dart';
import 'package:adjust_sdk/adjust_play_store_subscription.dart';
import 'package:adjust_sdk/adjust_purchase_verification_info.dart';
import 'package:adjust_sdk/adjust_third_party_sharing.dart';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Adjust {
  static const String _sdkPrefix = 'flutter4.35.2';
  static const MethodChannel _channel =
      const MethodChannel('com.adjust.sdk/api');

  static void start(AdjustConfig config) {
    config.sdkPrefix = _sdkPrefix;
    _channel.invokeMethod('start', config.toMap);
  }

  static void trackEvent(AdjustEvent event) {
    _channel.invokeMethod('trackEvent', event.toMap);
  }

  static void setEnabled(bool isEnabled) {
    _channel.invokeMethod('setEnabled', {'isEnabled': isEnabled});
  }

  static void setOfflineMode(bool isOffline) {
    _channel.invokeMethod('setOfflineMode', {'isOffline': isOffline});
  }

  static void setPushToken(String token) {
    _channel.invokeMethod('setPushToken', {'pushToken': token});
  }

  static void setReferrer(String referrer) {
    _channel.invokeMethod('setReferrer', {'referrer': referrer});
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

  static void disableThirdPartySharing() {
    _channel.invokeMethod('disableThirdPartySharing');
  }

  static void onResume() {
    _channel.invokeMethod('onResume');
  }

  static void onPause() {
    _channel.invokeMethod('onPause');
  }

  static Future<bool> isEnabled() async {
    final bool isEnabled = await _channel.invokeMethod('isEnabled');
    return isEnabled;
  }

  static Future<String?> getAdid() async {
    final String? adid = await _channel.invokeMethod('getAdid');
    return adid;
  }

  static Future<String?> getIdfa() async {
    final String? idfa = await _channel.invokeMethod('getIdfa');
    return idfa;
  }

  static Future<String?> getAmazonAdId() async {
    final String? amazonAdId = await _channel.invokeMethod('getAmazonAdId');
    return amazonAdId;
  }

  static Future<String?> getGoogleAdId() async {
    final String? googleAdId = await _channel.invokeMethod('getGoogleAdId');
    return googleAdId;
  }

  static Future<num> requestTrackingAuthorizationWithCompletionHandler() async {
    final num status = await _channel
        .invokeMethod('requestTrackingAuthorizationWithCompletionHandler');
    return status;
  }

  static Future<int> getAppTrackingAuthorizationStatus() async {
    final int authorizationStatus =
        await _channel.invokeMethod('getAppTrackingAuthorizationStatus');
    return authorizationStatus;
  }

  static Future<AdjustAttribution> getAttribution() async {
    final dynamic attributionMap =
        await _channel.invokeMethod('getAttribution');
    return AdjustAttribution.fromMap(attributionMap);
  }

  static Future<String> getSdkVersion() async {
    final String sdkVersion = await _channel.invokeMethod('getSdkVersion');
    return _sdkPrefix + '@' + sdkVersion;
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

  static void trackAdRevenue(String source, String payload) {
    _channel
        .invokeMethod('trackAdRevenue', {'source': source, 'payload': payload});
  }

  static void trackAdRevenueNew(AdjustAdRevenue adRevenue) {
    _channel.invokeMethod('trackAdRevenueNew', adRevenue.toMap);
  }

  static void trackAppStoreSubscription(
      AdjustAppStoreSubscription subscription) {
    _channel.invokeMethod('trackAppStoreSubscription', subscription.toMap);
  }

  static void trackPlayStoreSubscription(
      AdjustPlayStoreSubscription subscription) {
    _channel.invokeMethod('trackPlayStoreSubscription', subscription.toMap);
  }

  static void trackThirdPartySharing(
      AdjustThirdPartySharing thirdPartySharing) {
    _channel.invokeMethod('trackThirdPartySharing', thirdPartySharing.toMap);
  }

  static void trackMeasurementConsent(bool measurementConsent) {
    _channel.invokeMethod(
        'trackMeasurementConsent', {'measurementConsent': measurementConsent});
  }

  static void updateConversionValue(int conversionValue) {
    _channel.invokeMethod(
        'updateConversionValue', {'conversionValue': conversionValue});
  }

  static void checkForNewAttStatus() {
    _channel.invokeMethod('checkForNewAttStatus');
  }

  static Future<String?> getLastDeeplink() async {
    final String? deeplink = await _channel.invokeMethod('getLastDeeplink');
    return deeplink;
  }

  static Future<String?> updateConversionValueWithErrorCallback(int conversionValue) async {
    final String? error = await _channel.invokeMethod(
        'updateConversionValueWithErrorCallback', {'conversionValue': conversionValue});
    return error;
  }

  static Future<String?> updateConversionValueWithErrorCallbackSkad4(
    int conversionValue,
    String coarseValue,
    bool lockWindow) async {
    final String? error = await _channel.invokeMethod(
        'updateConversionValueWithErrorCallbackSkad4', {'conversionValue': conversionValue,
                                                   'coarseValue': coarseValue,
                                                   'lockWindow': lockWindow});
    return error;
  }

  static Future<AdjustPurchaseVerificationInfo?> verifyPlayStorePurchase(
    AdjustPlayStorePurchase purchase) async {
    final dynamic playStorePurchaseMap = 
      await _channel.invokeMethod('verifyPlayStorePurchase', purchase.toMap);
    return AdjustPurchaseVerificationInfo.fromMap(playStorePurchaseMap);
  }

  static Future<AdjustPurchaseVerificationInfo?> verifyAppStorePurchase(
    AdjustAppStorePurchase purchase) async {
    final dynamic appStorePurchaseMap = 
      await _channel.invokeMethod('verifyAppStorePurchase', purchase.toMap);
    return AdjustPurchaseVerificationInfo.fromMap(appStorePurchaseMap);
  }

  // For testing purposes only. Do not use in production.
  @visibleForTesting
  static void setTestOptions(final dynamic testOptions) {
    _channel.invokeMethod('setTestOptions', testOptions);
  }
}
