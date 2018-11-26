import 'dart:async';

import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Adjust {
  static const MethodChannel _channel = const MethodChannel('com.adjust/api');

  @experimental
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void onResume() {
    print('Calling "ON RESUME" from flutter...');
    _channel.invokeMethod('onResume');
  }

  static void onPause() {
    print('Calling "ON PAUSE" from flutter...');
    _channel.invokeMethod('onPause');
  }

  static Future<bool> isEnabled() async {
    final bool isEnabled = await _channel.invokeMethod('isEnabled');
    return isEnabled;
  }

  static void setIsEnabled(bool isEnabled) {
    _channel.invokeMethod('setIsEnabled', {'isEnabled': isEnabled});
  }

  static void onCreate(AdjustConfig config) {
    _channel.invokeMethod('onCreate', config.configParamsMap);
  }

  static void trackEvent(AdjustEvent adjustEvent) {
    _channel.invokeMethod('trackEvent', adjustEvent.adjustEventParamsMap);
  }

  static void setOfflineMode(bool isOffline) {
    _channel.invokeMethod('setOfflineMode', {'isOffline': isOffline});
  }

  static void setPushToken(String token) {
    _channel.invokeMethod('setPushToken', {'token': token});
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

  static Future<String> getAdid() async {
    final String adid = await _channel.invokeMethod('getAdid');
    return adid;
  }

  static Future<String> getIdfa() async {
    final String idfa = await _channel.invokeMethod('getIdfa');
    return idfa;
  }

  static Future<String> getAmazonAdId() async {
    final String amazonAdId = await _channel.invokeMethod('getAmazonAdId');
    return amazonAdId;
  }

  static void setReferrer(String referrer) {
    _channel.invokeMethod('setReferrer', {'referrer': referrer});
  }

  static Future<String> getGoogleAdId() async {
    final String googleAdId = await _channel.invokeMethod('getGoogleAdId');
    return googleAdId;
  }

  static Future<AdjustAttribution> getAttribution() async {
    final Map attributionMap = await _channel.invokeMethod('getAttribution');
    return AdjustAttribution.fromMap(attributionMap);
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

  // for integration testing only
  @visibleForTesting
  static void setTestOptions(final dynamic testOptions) {
    _channel.invokeMethod('setTestOptions', testOptions);
  }
}
