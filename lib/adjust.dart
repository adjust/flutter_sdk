//
//  adjust_sdk.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust_attribution.dart';

class Adjust {
  static const String _sdkPrefix = 'flutter0.0.3';
  static const MethodChannel _channel = const MethodChannel('com.adjust.sdk/api');

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

  static Future<String> getAdid() async {
    final String adid = await _channel.invokeMethod('getAdid');
    return adid;
  }

  static Future<String> getIdfa() async {
    try {
      final String idfa = await _channel.invokeMethod('getIdfa');
      return idfa;
    } catch (e) {
      return null;
    }
  }

  static Future<String> getAmazonAdId() async {
    try {
      final String amazonAdId = await _channel.invokeMethod('getAmazonAdId');
      return amazonAdId;
    } catch (e) {
      return null;
    }
  }

  static Future<String> getGoogleAdId() async {
    try {
      final String googleAdId = await _channel.invokeMethod('getGoogleAdId');
      return googleAdId;
    } catch (e) {
      return null;
    }
  }

  static Future<AdjustAttribution> getAttribution() async {
    final Map attributionMap = await _channel.invokeMethod('getAttribution');
    return AdjustAttribution.fromMap(attributionMap);
  }

  static Future<String> getSdkVersion() async {
    final String sdkVersion = await _channel.invokeMethod('getSdkVersion');
    return _sdkPrefix + '@' + sdkVersion;
  }

  static void addSessionCallbackParameter(String key, String value) {
    _channel.invokeMethod('addSessionCallbackParameter', {'key': key, 'value': value});
  }

  static void addSessionPartnerParameter(String key, String value) {
    _channel.invokeMethod('addSessionPartnerParameter', {'key': key, 'value': value});
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

  // For testing purposes only. Do not use in production.
  @visibleForTesting
  static void setTestOptions(final dynamic testOptions) {
    _channel.invokeMethod('setTestOptions', testOptions);
  }
}
