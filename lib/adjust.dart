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
import 'package:adjust_sdk/adjust_purchase_verification_result.dart';
import 'package:adjust_sdk/adjust_third_party_sharing.dart';
import 'package:adjust_sdk/adjust_deeplink.dart';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Adjust {
  static const String _sdkPrefix = 'flutter5.0.0';
  static const MethodChannel _channel =
      const MethodChannel('com.adjust.sdk/api');

  static void initSdk(AdjustConfig config) {
    config.sdkPrefix = _sdkPrefix;
    _channel.invokeMethod('initSdk', config.toMap);
  }

  static void trackEvent(AdjustEvent event) {
    _channel.invokeMethod('trackEvent', event.toMap);
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

  static void setPushToken(String token) {
    _channel.invokeMethod('setPushToken', {'pushToken': token});
  }

  static void processDeeplink(AdjustDeeplink deeplink) {
    _channel.invokeMethod('processDeeplink', {'deeplink': deeplink.deeplink});
  }

  static void gdprForgetMe() {
    _channel.invokeMethod('gdprForgetMe');
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

  static Future<String?> getIdfv() async {
    final String? idfv = await _channel.invokeMethod('getIdfv');
    return idfv;
  }

  static Future<String?> getAmazonAdId() async {
    final String? amazonAdId = await _channel.invokeMethod('getAmazonAdId');
    return amazonAdId;
  }

  static Future<String?> getGoogleAdId() async {
    final String? googleAdId = await _channel.invokeMethod('getGoogleAdId');
    return googleAdId;
  }

  static Future<num> requestAppTrackingAuthorization() async {
    final num status = await _channel
        .invokeMethod('requestAppTrackingAuthorization');
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

  static void trackAdRevenue(AdjustAdRevenue adRevenue) {
    _channel.invokeMethod('trackAdRevenue', adRevenue.toMap);
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

  static Future<String?> updateSkanConversionValue(int conversionValue, String coarseValue, bool lockWindow) async {
    final String error = await _channel.invokeMethod('updateSkanConversionValue', {
      'conversionValue': conversionValue,
      'coarseValue': coarseValue,
      'lockWindow': lockWindow
    });
    return error;
  }

  static Future<String?> getLastDeeplink() async {
    final String? deeplink = await _channel.invokeMethod('getLastDeeplink');
    return deeplink;
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

  static Future<String?> processAndResolveDeeplink(AdjustDeeplink deeplink) async {
    final resolvedLink = 
      await _channel.invokeMethod('processAndResolveDeeplink', {'deeplink': deeplink.deeplink});
    return resolvedLink;
  }

  // for testing purposes only, do not use in production!
  @visibleForTesting
  static void setTestOptions(final dynamic testOptions) {
    _channel.invokeMethod('setTestOptions', testOptions);
  }

  @visibleForTesting
  static void onResume() {
    _channel.invokeMethod('onResume');
  }

  @visibleForTesting
  static void onPause() {
    _channel.invokeMethod('onPause');
  }
}
