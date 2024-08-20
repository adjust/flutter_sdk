//
//  command_executor.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

import 'dart:io' show Platform;

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_ad_revenue.dart';
import 'package:adjust_sdk/adjust_app_store_subscription.dart';
import 'package:adjust_sdk/adjust_app_store_purchase.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_play_store_subscription.dart';
import 'package:adjust_sdk/adjust_play_store_purchase.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:adjust_sdk/adjust_third_party_sharing.dart';
import 'package:adjust_sdk/adjust_purchase_verification_info.dart';
import 'package:adjust_sdk/adjust_deeplink.dart';
import 'package:test_app/command.dart';
import 'package:test_lib/test_lib.dart';

class CommandExecutor {
  String? _baseUrl;
  String? _basePath;
  String? _gdprUrl;
  String? _gdprPath;
  String? _subscriptionUrl;
  String? _subscriptionPath;
  String? _purchaseVerificationUrl;
  String? _purchaseVerificationPath;
  String? _overwriteUrl;
  String? _extraPath;
  late Command _command;
  Map<int, AdjustEvent?> _savedEvents = new Map<int, AdjustEvent?>();
  Map<int, AdjustConfig?> _savedConfigs = new Map<int, AdjustConfig?>();

  CommandExecutor(String? overwriteUrl) {
    _baseUrl = overwriteUrl;
    _gdprUrl = overwriteUrl;
    _subscriptionUrl = overwriteUrl;
    _purchaseVerificationUrl = overwriteUrl;
    _overwriteUrl = overwriteUrl;
  }

  void executeCommand(Command command) {
    _command = command;
    switch (command.methodName) {
      case 'testOptions':
        _testOptions();
        break;
      case 'config':
        _config();
        break;
      case 'start':
        _initSdk();
        break;
      case 'event':
        _event();
        break;
      case 'trackEvent':
        _trackEvent();
        break;
      case 'resume':
        _resume();
        break;
      case 'pause':
        _pause();
        break;
      case 'setEnabled':
        _setEnabled();
        break;
      case 'setOfflineMode':
        _setOfflineMode();
        break;
      case 'addGlobalCallbackParameter':
        _addGlobalCallbackParameter();
        break;
      case 'addGlobalPartnerParameter':
        _addGlobalPartnerParameter();
        break;
      case 'removeGlobalCallbackParameter':
        _removeGlobalCallbackParameter();
        break;
      case 'removeGlobalPartnerParameter':
        _removeGlobalPartnerParameter();
        break;
      case 'removeGlobalCallbackParameters':
        _removeGlobalCallbackParameters();
        break;
      case 'removeGlobalPartnerParameters':
        _removeGlobalPartnerParameters();
        break;
      case 'setPushToken':
        _setPushToken();
        break;
      case 'openDeeplink':
        _openDeeplink();
        break;
      case 'gdprForgetMe':
        _gdprForgetMe();
        break;
      case 'trackSubscription':
        _trackSubscription();
        break;
      case 'thirdPartySharing':
        _trackThirdPartySharing();
        break;
      case 'measurementConsent':
        _trackMeasurementConsent();
        break;
      case 'trackAdRevenue':
        _trackAdRevenue();
        break;
      case 'getLastDeeplink':
        _getLastDeeplink();
        break;
      case 'verifyPurchase':
        _verifyPurchase();
        break;
      case 'verifyTrack':
        _verifyTrack();
        break;
      case 'processDeeplink':
        _processDeeplink();
        break;
      case 'attributionGetter':
        _attributionGetter();
        break;
    }
  }

  void _testOptions() {
    final dynamic testOptions = {};
    testOptions['baseUrl'] = _overwriteUrl;
    testOptions['gdprUrl'] = _overwriteUrl;
    testOptions['subscriptionUrl'] = _overwriteUrl;
    testOptions['purchaseVerificationUrl'] = _overwriteUrl;
    testOptions['urlOverwrite'] = _overwriteUrl;
    if (_command.containsParameter('basePath')) {
      _basePath = _command.getFirstParameterValue('basePath');
      _gdprPath = _command.getFirstParameterValue('basePath');
      _subscriptionPath = _command.getFirstParameterValue('basePath');
      _purchaseVerificationPath = _command.getFirstParameterValue('basePath');
      _extraPath = _command.getFirstParameterValue('basePath');
    }
    if (_command.containsParameter('timerInterval')) {
      testOptions['timerIntervalInMilliseconds'] =
          _command.getFirstParameterValue('timerInterval');
    }
    if (_command.containsParameter('timerStart')) {
      testOptions['timerStartInMilliseconds'] =
          _command.getFirstParameterValue('timerStart');
    }
    if (_command.containsParameter('sessionInterval')) {
      testOptions['sessionIntervalInMilliseconds'] =
          _command.getFirstParameterValue('sessionInterval');
    }
    if (_command.containsParameter('subsessionInterval')) {
      testOptions['subsessionIntervalInMilliseconds'] =
          _command.getFirstParameterValue('subsessionInterval');
    }
    if (_command.containsParameter('tryInstallReferrer')) {
      testOptions['tryInstallReferrer'] =
          _command.getFirstParameterValue('tryInstallReferrer');
    }
    if (_command.containsParameter('noBackoffWait')) {
      testOptions['noBackoffWait'] =
          _command.getFirstParameterValue('noBackoffWait');
    }
    if (_command.containsParameter("doNotIgnoreSystemLifecycleBootstrap")) {
      String? doNotIgnoreSystemLifecycleBootstrapString =
      _command.getFirstParameterValue("doNotIgnoreSystemLifecycleBootstrap");
      bool doNotIgnoreSystemLifecycleBootstrap = (doNotIgnoreSystemLifecycleBootstrapString == 'true');
      if (doNotIgnoreSystemLifecycleBootstrap) {
        testOptions['ignoreSystemLifecycleBootstrap'] = false;
      }
    }
    if (_command.containsParameter('adServicesFrameworkEnabled')) {
      testOptions['adServicesFrameworkEnabled'] =
          _command.getFirstParameterValue('adServicesFrameworkEnabled');
    }
    if (_command.containsParameter('attStatus')) {
      testOptions['attStatus'] =
          _command.getFirstParameterValue('attStatus');
    }
    if (_command.containsParameter('idfa')) {
      testOptions['idfa'] =
          _command.getFirstParameterValue('idfa');
    }
    bool useTestConnectionOptions = false;
    if (_command.containsParameter('teardown')) {
      List<dynamic> teardownOptions = _command.getParamteters('teardown')!;
      for (String teardownOption in teardownOptions) {
        if (teardownOption == 'resetSdk') {
          testOptions['teardown'] = 'true';
          testOptions['basePath'] = _extraPath;
          testOptions['gdprPath'] = _extraPath;
          testOptions['subscriptionPath'] = _extraPath;
          testOptions['purchaseVerificationPath'] = _extraPath;
          testOptions['extraPath'] = _extraPath;
          // Android specific
          testOptions['useTestConnectionOptions'] = 'true';
          testOptions['tryInstallReferrer'] = 'false';
          useTestConnectionOptions = true;
        }
        if (teardownOption == 'deleteState') {
          testOptions['deleteState'] = 'true';
        }
        if (teardownOption == 'resetTest') {
          _savedEvents.clear();
          _savedConfigs.clear();
          testOptions['timerIntervalInMilliseconds'] = '-1';
          testOptions['timerStartInMilliseconds'] = '-1';
          testOptions['sessionIntervalInMilliseconds'] = '-1';
          testOptions['subsessionIntervalInMilliseconds'] = '-1';
        }
        if (teardownOption == 'sdk') {
          testOptions['teardown'] = 'true';
          testOptions['basePath'] = null;
          testOptions['gdprPath'] = null;
          testOptions['subscriptionPath'] = null;
          testOptions['extraPath'] = null;
          // Android specific.
          testOptions['useTestConnectionOptions'] = 'false';
          useTestConnectionOptions = false;
        }
        if (teardownOption == 'test') {
          _savedEvents.clear();
          _savedConfigs.clear();
          testOptions['timerIntervalInMilliseconds'] = '-1';
          testOptions['timerStartInMilliseconds'] = '-1';
          testOptions['sessionIntervalInMilliseconds'] = '-1';
          testOptions['subsessionIntervalInMilliseconds'] = '-1';
        }
      }
    }
    Adjust.setTestOptions(testOptions);
    if (useTestConnectionOptions == true) {
      TestLib.setTestConnectionOptions();
    }
  }

  void _config() {
    int configNumber = 0;
    if (_command.containsParameter('configName')) {
      String configName = _command.getFirstParameterValue('configName')!;
      configNumber = int.parse(configName.substring(configName.length - 1));
    }

    AdjustConfig? adjustConfig;
    if (_savedConfigs[configNumber] != null) {
      adjustConfig = _savedConfigs[configNumber];
    } else {
      String appToken = _command.getFirstParameterValue('appToken')!;
      String? environmentString =
          _command.getFirstParameterValue('environment');
      AdjustEnvironment environment = environmentString == 'sandbox'
          ? AdjustEnvironment.sandbox
          : AdjustEnvironment.production;
      adjustConfig = new AdjustConfig(appToken, environment);
      adjustConfig.logLevel = AdjustLogLevel.verbose;
      _savedConfigs.putIfAbsent(configNumber, () => adjustConfig);
    }

    if (_command.containsParameter('logLevel')) {
      String? logLevelString = _command.getFirstParameterValue('logLevel');
      AdjustLogLevel? logLevel;
      switch (logLevelString) {
        case 'verbose':
          logLevel = AdjustLogLevel.verbose;
          break;
        case 'debug':
          logLevel = AdjustLogLevel.debug;
          break;
        case 'info':
          logLevel = AdjustLogLevel.info;
          break;
        case 'warn':
          logLevel = AdjustLogLevel.warn;
          break;
        case 'error':
          logLevel = AdjustLogLevel.error;
          break;
        case 'suppress':
          logLevel = AdjustLogLevel.suppress;
          break;
      }
      adjustConfig!.logLevel = logLevel;
    }

    if (_command.containsParameter('defaultTracker')) {
      adjustConfig!.defaultTracker =
          _command.getFirstParameterValue('defaultTracker');
    }

    if (_command.containsParameter('externalDeviceId')) {
      adjustConfig!.externalDeviceId =
          _command.getFirstParameterValue('externalDeviceId');
    }

    if (_command.containsParameter('coppaCompliant')) {
      adjustConfig!.isCoppaComplianceEnabled =
          _command.getFirstParameterValue('coppaCompliant') == 'true';
    }

    if (_command.containsParameter('playStoreKids')) {
      adjustConfig!.isPlayStoreKidsComplianceEnabled =
          _command.getFirstParameterValue('playStoreKids') == 'true';
    }

    if (_command.containsParameter('sendInBackground')) {
      if(_command.getFirstParameterValue('sendInBackground') == 'true')
      adjustConfig!.isSendingInBackgroundEnabled = true;
    }

    if (_command.containsParameter('allowAdServicesInfoReading')) {
      if(_command.getFirstParameterValue('allowAdServicesInfoReading') ==
          'false'){
        adjustConfig!.isAdServicesEnabled = false;
      }
    }

    if (_command.containsParameter('eventDeduplicationIdsMaxSize')) {
      String? maxIds = _command.getFirstParameterValue("eventDeduplicationIdsMaxSize");
      int maxIdCount = int.parse(maxIds!);
      adjustConfig!.eventDeduplicationIdsMaxSize = maxIdCount;
    }

    if (_command.containsParameter('allowSkAdNetworkHandling')) {
      if (_command.getFirstParameterValue('allowSkAdNetworkHandling') ==
          'false') {
        adjustConfig!.isSkanAttributionEnabled = false;
      }
    }

    if (_command.containsParameter('allowIdfaReading')) {
      if(_command.getFirstParameterValue('allowIdfaReading') == 'false') {
        adjustConfig!.isIdfaReadingEnabled = false;
      }
    }

    if (_command.containsParameter('attConsentWaitingSeconds')) {
      adjustConfig!.attConsentWaitingInterval =
          double.parse(_command.getFirstParameterValue('attConsentWaitingSeconds')!);
    }

    // First clear all previous callback handlers.
    adjustConfig!.attributionCallback = null;
    adjustConfig.sessionSuccessCallback = null;
    adjustConfig.sessionFailureCallback = null;
    adjustConfig.eventSuccessCallback = null;
    adjustConfig.eventFailureCallback = null;
    adjustConfig.deferredDeeplinkCallback = null;
    adjustConfig.skanUpdatedCallback = null;

    // TODO: Deeplinking in Flutter example.
    // https://github.com/flutter/flutter/issues/8711#issuecomment-304681212
    if (_command.containsParameter('deferredDeeplinkCallback')) {
      String? localBasePath = _extraPath;
      adjustConfig.isDeferredDeeplinkOpeningEnabled =
          _command.getFirstParameterValue('deferredDeeplinkCallback') == 'true';
      print(
          '[CommandExecutor]: Deferred deeplink callback, isDeferredDeeplinkOpeningEnabled: ${adjustConfig.isDeferredDeeplinkOpeningEnabled}');
      adjustConfig.deferredDeeplinkCallback = (String? uri) {
        print('[CommandExecutor]: Sending deeplink info to server: $uri');
        TestLib.addInfoToSend('deeplink', uri);
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('attributionCallbackSendAll')) {
      String? localBasePath = _extraPath;
      adjustConfig.attributionCallback = (AdjustAttribution attribution) {
        print('[CommandExecutor]: Attribution Callback: $attribution');
        TestLib.addInfoToSend('tracker_token', attribution.trackerToken);
        TestLib.addInfoToSend('tracker_name', attribution.trackerName);
        TestLib.addInfoToSend('network', attribution.network);
        TestLib.addInfoToSend('campaign', attribution.campaign);
        TestLib.addInfoToSend('adgroup', attribution.adgroup);
        TestLib.addInfoToSend('creative', attribution.creative);
        TestLib.addInfoToSend('click_label', attribution.clickLabel);
        TestLib.addInfoToSend('cost_type', attribution.costType);
        TestLib.addInfoToSend('cost_amount', attribution.costAmount.toString());
        TestLib.addInfoToSend('cost_currency', attribution.costCurrency);
        TestLib.addInfoToSend('fb_install_referrer', attribution.fbInstallReferrer);
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('sessionCallbackSendSuccess')) {
      String? localBasePath = _extraPath;
      adjustConfig.sessionSuccessCallback =
          (AdjustSessionSuccess sessionSuccessResponseData) {
        print(
            '[CommandExecutor]: Session Callback Success: $sessionSuccessResponseData');
        TestLib.addInfoToSend('message', sessionSuccessResponseData.message);
        TestLib.addInfoToSend(
            'timestamp', sessionSuccessResponseData.timestamp);
        TestLib.addInfoToSend('adid', sessionSuccessResponseData.adid);
        if (sessionSuccessResponseData.jsonResponse != null) {
          TestLib.addInfoToSend(
              'jsonResponse', sessionSuccessResponseData.jsonResponse);
        }
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('sessionCallbackSendFailure')) {
      String? localBasePath = _extraPath;
      adjustConfig.sessionFailureCallback =
          (AdjustSessionFailure sessionFailureResponseData) {
        print(
            '[CommandExecutor]: Session Callback Failure: $sessionFailureResponseData');
        TestLib.addInfoToSend('message', sessionFailureResponseData.message);
        TestLib.addInfoToSend(
            'timestamp', sessionFailureResponseData.timestamp);
        TestLib.addInfoToSend('adid', sessionFailureResponseData.adid);
        TestLib.addInfoToSend(
            'willRetry', sessionFailureResponseData.willRetry.toString());
        if (sessionFailureResponseData.jsonResponse != null) {
          TestLib.addInfoToSend(
              'jsonResponse', sessionFailureResponseData.jsonResponse);
        }
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('eventCallbackSendSuccess')) {
      String? localBasePath = _extraPath;
      adjustConfig.eventSuccessCallback =
          (AdjustEventSuccess eventSuccessResponseData) {
        print(
            '[CommandExecutor]: Event Callback Success: $eventSuccessResponseData');
        TestLib.addInfoToSend('message', eventSuccessResponseData.message);
        TestLib.addInfoToSend('timestamp', eventSuccessResponseData.timestamp);
        TestLib.addInfoToSend('adid', eventSuccessResponseData.adid);
        TestLib.addInfoToSend(
            'eventToken', eventSuccessResponseData.eventToken);
        TestLib.addInfoToSend(
            'callbackId', eventSuccessResponseData.callbackId);
        if (eventSuccessResponseData.jsonResponse != null) {
          TestLib.addInfoToSend(
              'jsonResponse', eventSuccessResponseData.jsonResponse);
        }
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('eventCallbackSendFailure')) {
      String? localBasePath = _extraPath;
      adjustConfig.eventFailureCallback =
          (AdjustEventFailure eventFailureResponseData) {
        print(
            '[CommandExecutor]: Event Callback Failure: $eventFailureResponseData');
        TestLib.addInfoToSend('message', eventFailureResponseData.message);
        TestLib.addInfoToSend('timestamp', eventFailureResponseData.timestamp);
        TestLib.addInfoToSend('adid', eventFailureResponseData.adid);
        TestLib.addInfoToSend(
            'eventToken', eventFailureResponseData.eventToken);
        TestLib.addInfoToSend(
            'callbackId', eventFailureResponseData.callbackId);
        TestLib.addInfoToSend(
            'willRetry', eventFailureResponseData.willRetry.toString());
        if (eventFailureResponseData.jsonResponse != null) {
          TestLib.addInfoToSend(
              'jsonResponse', eventFailureResponseData.jsonResponse.toString());
        }
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('skanCallback')) {
      String? localBasePath = _extraPath;
      adjustConfig.skanUpdatedCallback =
          (Map<String, String> data) {
        print(
            '[CommandExecutor]: Skan Callback: $data');
        data.forEach((k, v) => TestLib.addInfoToSend(k, v));
        TestLib.sendInfoToServer(localBasePath);
      };
    }
  }

  void _initSdk() {
    _config();
    int configNumber = 0;
    if (_command.containsParameter('configName')) {
      String configName = _command.getFirstParameterValue('configName')!;
      configNumber = int.parse(configName.substring(configName.length - 1));
    }

    AdjustConfig adjustConfig = _savedConfigs[configNumber]!;
    Adjust.initSdk(adjustConfig);
    _savedConfigs.remove(configNumber);
  }

  void _event() {
    int eventNumber = 0;
    if (_command.containsParameter('eventNumber')) {
      String eventName = _command.getFirstParameterValue('eventName')!;
      eventNumber = int.parse(eventName.substring(eventName.length - 1));
    }

    AdjustEvent? adjustEvent;
    if (_savedConfigs[eventNumber] != null) {
      adjustEvent = _savedEvents[eventNumber];
    } else {
      String eventToken = _command.getFirstParameterValue('eventToken')!;
      adjustEvent = new AdjustEvent(eventToken);
      _savedEvents.putIfAbsent(eventNumber, () => adjustEvent);
    }

    if (_command.containsParameter('revenue')) {
      List<dynamic> revenueParams = _command.getParamteters('revenue')!;
      // TODO: find better way to filter null values for Flutter platform
      if (revenueParams[0] != null && revenueParams[1] != null) {
        adjustEvent!.setRevenue(num.parse(revenueParams[1]), revenueParams[0]);
      }
    }
    if (_command.containsParameter('callbackParams')) {
      List<dynamic> callbackParams = _command.getParamteters('callbackParams')!;
      for (int i = 0; i < callbackParams.length; i = i + 2) {
        if (callbackParams[i] != null && callbackParams[i + 1] != null) {
          String key = callbackParams[i];
          String value = callbackParams[i + 1];
          adjustEvent!.addCallbackParameter(key, value);
        }
      }
    }
    if (_command.containsParameter('partnerParams')) {
      List<dynamic> partnerParams = _command.getParamteters('partnerParams')!;
      for (int i = 0; i < partnerParams.length; i = i + 2) {
        if (partnerParams[i] != null && partnerParams[i + 1] != null) {
          String key = partnerParams[i];
          String value = partnerParams[i + 1];
          adjustEvent!.addPartnerParameter(key, value);
        }
      }
    }
    if (_command.containsParameter('orderId')) {
      adjustEvent!.transactionId = _command.getFirstParameterValue('orderId');
    }
    if (_command.containsParameter('productId')) {
      adjustEvent!.productId = _command.getFirstParameterValue('productId');
    }
    if (_command.containsParameter('transactionId')) {
      adjustEvent!.transactionId = _command.getFirstParameterValue('transactionId');
    }
    if (_command.containsParameter('deduplicationId')) {
      adjustEvent!.deduplicationId = _command.getFirstParameterValue('deduplicationId');
    }
    if (_command.containsParameter('purchaseToken')) {
      adjustEvent!.purchaseToken = _command.getFirstParameterValue('purchaseToken');
    }
    if (_command.containsParameter('callbackId')) {
      adjustEvent!.callbackId = _command.getFirstParameterValue('callbackId');
    }
  }

  void _trackEvent() {
    _event();
    int eventNumber = 0;
    if (_command.containsParameter('eventName')) {
      String eventName = _command.getFirstParameterValue('eventName')!;
      eventNumber = int.parse(eventName.substring(eventName.length - 1));
    }

    AdjustEvent adjustEvent = _savedEvents[eventNumber]!;
    Adjust.trackEvent(adjustEvent);

    _savedEvents.remove(eventNumber);
  }

  void _resume() {
    Adjust.onResume();
  }

  void _pause() {
    Adjust.onPause();
  }

  void _setEnabled() {
    bool isEnabled = _command.getFirstParameterValue('enabled') == 'true';
    if(isEnabled) {
      Adjust.enable();
    }else{
      Adjust.disable();
    }
  }

  void _setOfflineMode() {
    bool isEnabled = _command.getFirstParameterValue('enabled') == 'true';
    if(isEnabled){
     Adjust.switchToOfflineMode();
    }else{
      Adjust.switchBackToOnlineMode();
    }
  }

  void _setPushToken() {
    String token = _command.getFirstParameterValue('pushToken')!;
    Adjust.setPushToken(token);
  }

  void _openDeeplink() {
    String deeplink = _command.getFirstParameterValue('deeplink')!;
    AdjustDeeplink adjustDeeplink = new AdjustDeeplink(deeplink);
    Adjust.processDeeplink(adjustDeeplink);
  }

  void _gdprForgetMe() {
    Adjust.gdprForgetMe();
  }

  void _addGlobalCallbackParameter() {
    if (!_command.containsParameter('KeyValue')) {
      return;
    }

    List<dynamic> keyValuePairs = _command.getParamteters('KeyValue')!;
    for (int i = 0; i < keyValuePairs.length; i = i + 2) {
      String key = keyValuePairs[i];
      String value = keyValuePairs[i + 1];
      Adjust.addGlobalCallbackParameter(key, value);
    }
  }

  void _addGlobalPartnerParameter() {
    if (!_command.containsParameter('KeyValue')) {
      return;
    }

    List<dynamic> keyValuePairs = _command.getParamteters('KeyValue')!;
    for (int i = 0; i < keyValuePairs.length; i = i + 2) {
      String key = keyValuePairs[i];
      String value = keyValuePairs[i + 1];
      Adjust.addGlobalPartnerParameter(key, value);
    }
  }

  void _removeGlobalCallbackParameter() {
    if (!_command.containsParameter('key')) {
      return;
    }

    List<dynamic> keys = _command.getParamteters('key')!;
    for (int i = 0; i < keys.length; i = i + 1) {
      String key = keys[i];
      Adjust.removeGlobalCallbackParameter(key);
    }
  }

  void _removeGlobalPartnerParameter() {
    if (!_command.containsParameter('key')) {
      return;
    }

    List<dynamic> keys = _command.getParamteters('key')!;
    for (int i = 0; i < keys.length; i = i + 1) {
      String key = keys[i];
      Adjust.removeGlobalPartnerParameter(key);
    }
  }

  void _removeGlobalCallbackParameters() {
    Adjust.removeGlobalCallbackParameters();
  }

  void _removeGlobalPartnerParameters() {
    Adjust.removeGlobalPartnerParameters();
  }

  void _trackSubscription() {
    if (Platform.isIOS) {
      String price = _command.getFirstParameterValue('revenue')!;
      String currency = _command.getFirstParameterValue('currency')!;
      String transactionId = _command.getFirstParameterValue('transactionId')!;
      String transactionDate =
          _command.getFirstParameterValue('transactionDate')!;
      String salesRegion = _command.getFirstParameterValue('salesRegion')!;

      AdjustAppStoreSubscription subscription = new AdjustAppStoreSubscription(
          price, currency, transactionId);

      subscription.transactionDate = transactionDate;
      subscription.salesRegion = salesRegion;

      if (_command.containsParameter('callbackParams')) {
        List<dynamic> callbackParams =
            _command.getParamteters('callbackParams')!;
        for (int i = 0; i < callbackParams.length; i = i + 2) {
          if (callbackParams[i] != null && callbackParams[i + 1] != null) {
            String key = callbackParams[i];
            String value = callbackParams[i + 1];
            subscription.addCallbackParameter(key, value);
          }
        }
      }
      if (_command.containsParameter('partnerParams')) {
        List<dynamic> partnerParams = _command.getParamteters('partnerParams')!;
        for (int i = 0; i < partnerParams.length; i = i + 2) {
          if (partnerParams[i] != null && partnerParams[i + 1] != null) {
            String key = partnerParams[i];
            String value = partnerParams[i + 1];
            subscription.addPartnerParameter(key, value);
          }
        }
      }

      Adjust.trackAppStoreSubscription(subscription);
    } else if (Platform.isAndroid) {
      String price = _command.getFirstParameterValue('revenue')!;
      String currency = _command.getFirstParameterValue('currency')!;
      String sku = _command.getFirstParameterValue('productId')!;
      String signature = _command.getFirstParameterValue('receipt')!;
      String purchaseToken = _command.getFirstParameterValue('purchaseToken')!;
      String orderId = _command.getFirstParameterValue('transactionId')!;
      String purchaseTime = _command.getFirstParameterValue('transactionDate')!;

      AdjustPlayStoreSubscription subscription =
          new AdjustPlayStoreSubscription(
              price, currency, sku, orderId, signature, purchaseToken);
      subscription.purchaseTime = purchaseTime;

      if (_command.containsParameter('callbackParams')) {
        List<dynamic> callbackParams =
            _command.getParamteters('callbackParams')!;
        for (int i = 0; i < callbackParams.length; i = i + 2) {
          if (callbackParams[i] != null && callbackParams[i + 1] != null) {
            String key = callbackParams[i];
            String value = callbackParams[i + 1];
            subscription.addCallbackParameter(key, value);
          }
        }
      }
      if (_command.containsParameter('partnerParams')) {
        List<dynamic> partnerParams = _command.getParamteters('partnerParams')!;
        for (int i = 0; i < partnerParams.length; i = i + 2) {
          if (partnerParams[i] != null && partnerParams[i + 1] != null) {
            String key = partnerParams[i];
            String value = partnerParams[i + 1];
            subscription.addPartnerParameter(key, value);
          }
        }
      }

      Adjust.trackPlayStoreSubscription(subscription);
    }
  }

  void _trackThirdPartySharing() {
    bool? isEnabled;
    if (_command.containsParameter('isEnabled')) {
      isEnabled = _command.getFirstParameterValue('isEnabled') == 'true';
    }
    AdjustThirdPartySharing adjustThirdPartySharing =
        new AdjustThirdPartySharing(isEnabled);

    if (_command.containsParameter('granularOptions')) {
      List<dynamic> granularOptions =
          _command.getParamteters('granularOptions')!;
      for (var i = 0; i < granularOptions.length; i += 3) {
        if (granularOptions[i] != null && granularOptions[i + 1] != null && granularOptions[i + 2] != null) {
          String partnerName = granularOptions[i];
          String key = granularOptions[i + 1];
          String value = granularOptions[i + 2];
          adjustThirdPartySharing.addGranularOption(partnerName, key, value);
        }
      }
    }

    if (_command.containsParameter('partnerSharingSettings')) {
      List<dynamic> partnerSharingSettings =
          _command.getParamteters('partnerSharingSettings')!;
      for (var i = 0; i < partnerSharingSettings.length; i += 3) {
        if (partnerSharingSettings[i] != null && partnerSharingSettings[i + 1] != null && partnerSharingSettings[i + 2] != null) {
          String partnerName = partnerSharingSettings[i];
          String key = partnerSharingSettings[i + 1];
          bool value = partnerSharingSettings[i + 2] == 'true';
          adjustThirdPartySharing.addPartnerSharingSetting(partnerName, key, value);
        }
      }
    }

    Adjust.trackThirdPartySharing(adjustThirdPartySharing);
  }

  void _trackMeasurementConsent() {
    bool isEnabled = _command.getFirstParameterValue('isEnabled') == 'true';
    Adjust.trackMeasurementConsent(isEnabled);
  }

  void _trackAdRevenue() {
    String source = _command.getFirstParameterValue('adRevenueSource')!;
    AdjustAdRevenue adjustAdRevenue = new AdjustAdRevenue(source);

    if (_command.containsParameter('revenue')) {
      List<dynamic> revenueParams = _command.getParamteters('revenue')!;
      adjustAdRevenue.setRevenue(num.parse(revenueParams[1]), revenueParams[0]);
    }
    if (_command.containsParameter('callbackParams')) {
      List<dynamic> callbackParams = _command.getParamteters('callbackParams')!;
      for (int i = 0; i < callbackParams.length; i = i + 2) {
        if (callbackParams[i] != null && callbackParams[i + 1] != null) {
          String key = callbackParams[i];
          String value = callbackParams[i + 1];
          adjustAdRevenue.addCallbackParameter(key, value);
        }
      }
    }
    if (_command.containsParameter('partnerParams')) {
      List<dynamic> partnerParams = _command.getParamteters('partnerParams')!;
      for (int i = 0; i < partnerParams.length; i = i + 2) {
        if (partnerParams[i] != null && partnerParams[i + 1] != null) {
          String key = partnerParams[i];
          String value = partnerParams[i + 1];
          adjustAdRevenue.addPartnerParameter(key, value);
        }
      }
    }
    if (_command.containsParameter('adImpressionsCount')) {
      adjustAdRevenue.adImpressionsCount =
          int.parse(_command.getFirstParameterValue('adImpressionsCount')!);
    }
    if (_command.containsParameter('adRevenueUnit')) {
      adjustAdRevenue.adRevenueUnit =
          _command.getFirstParameterValue('adRevenueUnit');
    }
    if (_command.containsParameter('adRevenuePlacement')) {
      adjustAdRevenue.adRevenuePlacement =
          _command.getFirstParameterValue('adRevenuePlacement');
    }
    if (_command.containsParameter('adRevenueNetwork')) {
      adjustAdRevenue.adRevenueNetwork =
          _command.getFirstParameterValue('adRevenueNetwork');
    }

    Adjust.trackAdRevenue(adjustAdRevenue);
  }

  void _getLastDeeplink() {
    if (Platform.isIOS) {
      Adjust.getLastDeeplink().then((lastDeeplink) {
        String? localBasePath = _basePath;
        TestLib.addInfoToSend('last_deeplink', lastDeeplink);
        TestLib.sendInfoToServer(localBasePath);
      });
    }
  }

  void _verifyPurchase() {
    if (Platform.isIOS) {
      String productId = _command.getFirstParameterValue('productId')!;
      String transactionId = _command.getFirstParameterValue('transactionId')!;

      AdjustAppStorePurchase purchase =
          new AdjustAppStorePurchase(productId, transactionId);

      Adjust.verifyAppStorePurchase(purchase).then((result) {
        String? localBasePath = _basePath;
        TestLib.addInfoToSend('verification_status', result?.verificationStatus);
        TestLib.addInfoToSend('code', result?.code.toString());
        TestLib.addInfoToSend('message', result?.message);
        TestLib.sendInfoToServer(localBasePath);
      });
    } else if (Platform.isAndroid) {
      String productId = _command.getFirstParameterValue('productId')!;
      String purchaseToken = _command.getFirstParameterValue('purchaseToken')!;

      AdjustPlayStorePurchase purchase =
          new AdjustPlayStorePurchase(productId, purchaseToken);

      Adjust.verifyPlayStorePurchase(purchase).then((result) {
        String? localBasePath = _basePath;
        TestLib.addInfoToSend('verification_status', result?.verificationStatus);
        TestLib.addInfoToSend('code', result?.code.toString());
        TestLib.addInfoToSend('message', result?.message);
        TestLib.sendInfoToServer(localBasePath);
      });
    }
  }

  void _verifyTrack() {
    _event();
    int eventNumber = 0;
    if (_command.containsParameter("eventName")) {
      String eventName = _command.getFirstParameterValue("eventName")!;
      eventNumber = int.parse(eventName.substring(eventName.length - 1));
    }

    AdjustEvent adjustEvent = _savedEvents[eventNumber]!;

    if (Platform.isIOS) {
      Adjust.verifyAndTrackAppStorePurchase(adjustEvent).then((result) {
        String? localBasePath = _basePath;
        TestLib.addInfoToSend('verification_status', result?.verificationStatus);
        TestLib.addInfoToSend('code', result?.code.toString());
        TestLib.addInfoToSend('message', result?.message);
        TestLib.sendInfoToServer(localBasePath);
      });
    } else if (Platform.isAndroid) {
      Adjust.verifyAndTrackPlayStorePurchase(adjustEvent).then((result) {
        String? localBasePath = _basePath;
        TestLib.addInfoToSend('verification_status', result?.verificationStatus);
        TestLib.addInfoToSend('code', result?.code.toString());
        TestLib.addInfoToSend('message', result?.message);
        TestLib.sendInfoToServer(localBasePath);
      });
    }

    _savedEvents.remove(eventNumber);
  }

  void _processDeeplink() {
    String deeplink = _command.getFirstParameterValue('deeplink')!;
    AdjustDeeplink adjustDeeplink = new AdjustDeeplink(deeplink);
    Adjust.processAndResolveDeeplink(adjustDeeplink).then((resolvedLink) {
      String? localBasePath = _basePath;
      TestLib.addInfoToSend('resolved_link', resolvedLink);
      TestLib.sendInfoToServer(localBasePath);
    });
  }

  void _attributionGetter() {
    Adjust.getAttribution().then((attribution){
      if(attribution != null) {
        Map<String, String?> fields = new Map();
        fields["tracker_token"] = attribution.trackerToken;
        fields["tracker_name"] = attribution.trackerName;
        fields["network"] = attribution.network;
        fields["campaign"] = attribution.campaign;
        fields["adgroup"] = attribution.adgroup;
        fields["creative"] = attribution.creative;
        fields["click_label"] = attribution.clickLabel;
        fields["cost_type"] = attribution.costType;
        fields["cost_amount"] = attribution.costAmount?.toString();
        fields["cost_currency"] = attribution.costCurrency;
        fields["fb_install_referrer"] = attribution.fbInstallReferrer;
        fields.forEach((key, value) {
          TestLib.addInfoToSend(key, value);
        });
        TestLib.sendInfoToServer(_basePath);
      }
    });
  }
}
