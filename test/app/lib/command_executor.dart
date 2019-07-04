import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:test_lib/test_lib.dart';
import 'package:test_app/command.dart';

class CommandExecutor {
  String _baseUrl;
  String _basePath;
  String _gdprUrl;
  String _gdprPath;
  Command _command;
  Map<int, AdjustEvent> _savedEvents = new Map<int, AdjustEvent>();
  Map<int, AdjustConfig> _savedConfigs = new Map<int, AdjustConfig>();

  CommandExecutor(String baseUrl, String gdprUrl) {
    _baseUrl = baseUrl;
    _gdprUrl = gdprUrl;
  }

  void executeCommand(Command command) {
    _command = command;
    switch (command.methodName) {
        case 'testOptions': _testOptions(); break;
        case 'config': _config(); break;
        case 'start': _start(); break;
        case 'event': _event(); break;
        case 'trackEvent': _trackEvent(); break;
        case 'resume': _resume(); break;
        case 'pause': _pause(); break;
        case 'setEnabled': _setEnabled(); break;
        case 'setReferrer': _setReferrer(); break;
        case 'sendReferrer': _setReferrer(); break;
        case 'setOfflineMode': _setOfflineMode(); break;
        case 'sendFirstPackages': _sendFirstPackages(); break;
        case 'addSessionCallbackParameter': _addSessionCallbackParameter(); break;
        case 'addSessionPartnerParameter': _addSessionPartnerParameter(); break;
        case 'removeSessionCallbackParameter': _removeSessionCallbackParameter(); break;
        case 'removeSessionPartnerParameter': _removeSessionPartnerParameter(); break;
        case 'resetSessionCallbackParameters': _resetSessionCallbackParameters(); break;
        case 'resetSessionPartnerParameters': _resetSessionPartnerParameters(); break;
        case 'setPushToken': _setPushToken(); break;
        case 'openDeeplink': _openDeeplink(); break;
        case 'gdprForgetMe': _gdprForgetMe(); break;
        case 'trackAdRevenue': _trackAdRevenue(); break;
    }
  }

  void _testOptions() {
    final dynamic testOptions = {};
    testOptions['baseUrl'] = _baseUrl;
    testOptions['gdprUrl'] = _gdprUrl;
    if (_command.containsParameter('basePath')) {
      _basePath = _command.getFirstParameterValue('basePath');
      _gdprPath = _command.getFirstParameterValue('basePath');
    }
    if (_command.containsParameter('timerInterval')) {
      testOptions['timerIntervalInMilliseconds'] = _command.getFirstParameterValue('timerInterval');
    }
    if (_command.containsParameter('timerStart')) {
      testOptions['timerStartInMilliseconds'] = _command.getFirstParameterValue('timerStart');
    }
    if (_command.containsParameter('sessionInterval')) {
      testOptions['sessionIntervalInMilliseconds'] = _command.getFirstParameterValue('sessionInterval');
    }
    if (_command.containsParameter('subsessionInterval')) {
      testOptions['subsessionIntervalInMilliseconds'] = _command.getFirstParameterValue('subsessionInterval');
    }
    if (_command.containsParameter('tryInstallReferrer')) {
      testOptions['tryInstallReferrer'] = _command.getFirstParameterValue('tryInstallReferrer');
    }
    if (_command.containsParameter('noBackoffWait')) {
      testOptions['noBackoffWait'] = _command.getFirstParameterValue('noBackoffWait');
    }
    if (_command.containsParameter('iAdFrameworkEnabled')) {
      testOptions['iAdFrameworkEnabled'] = _command.getFirstParameterValue('iAdFrameworkEnabled');
    }
    if (_command.containsParameter('teardown')) {
      List<dynamic> teardownOptions = _command.getParamteters('teardown');
      for (String teardownOption in teardownOptions) {
        if (teardownOption == 'resetSdk') {
          testOptions['teardown'] = 'true';
          testOptions['basePath'] = _basePath;
          testOptions['gdprPath'] = _gdprPath;
          // android specific
          testOptions['useTestConnectionOptions'] = 'true';
          testOptions['tryInstallReferrer'] = 'false';
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
          // Android specific.
          testOptions['useTestConnectionOptions'] = 'false';
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
  }

  void _config() {
    int configNumber = 0;
    if (_command.containsParameter('configName')) {
      String configName = _command.getFirstParameterValue('configName');
      configNumber = int.parse(configName.substring(configName.length - 1));
    }

    AdjustConfig adjustConfig;
    if (_savedConfigs[configNumber] != null) {
      adjustConfig = _savedConfigs[configNumber];
    } else {
      String appToken = _command.getFirstParameterValue('appToken');
      String environmentString = _command.getFirstParameterValue('environment');
      AdjustEnvironment environment = environmentString == 'sandbox' ? AdjustEnvironment.sandbox : AdjustEnvironment.production;
      adjustConfig = new AdjustConfig(appToken, environment);
      adjustConfig.logLevel = AdjustLogLevel.verbose;
      _savedConfigs.putIfAbsent(configNumber, () => adjustConfig);
    }

    if (_command.containsParameter('logLevel')) {
      String logLevelString = _command.getFirstParameterValue('logLevel');
      AdjustLogLevel logLevel;
      switch (logLevelString) {
          case 'verbose': logLevel = AdjustLogLevel.verbose;
              break;
          case 'debug': logLevel = AdjustLogLevel.debug;
              break;
          case 'info': logLevel = AdjustLogLevel.info;
              break;
          case 'warn': logLevel = AdjustLogLevel.warn;
              break;
          case 'error': logLevel = AdjustLogLevel.error;
              break;
          case 'suppress': logLevel = AdjustLogLevel.suppress;
              break;
      }
      adjustConfig.logLevel = logLevel;
    }

    if (_command.containsParameter('defaultTracker')) {
      adjustConfig.defaultTracker = _command.getFirstParameterValue('defaultTracker');
    }

    if (_command.containsParameter('appSecret')) {
      List<dynamic> appSecretArray = _command.getParamteters('appSecret');
      bool appSecretValid = true;
      for (String appSecretData in appSecretArray) {
        if (appSecretData.length == 0) {
          appSecretValid = false;
          break;
        }
      }

      if (appSecretValid) {
        num secretId = num.parse(appSecretArray[0]);
        num info1 = num.parse(appSecretArray[1]);
        num info2 = num.parse(appSecretArray[2]);
        num info3 = num.parse(appSecretArray[3]);
        num info4 = num.parse(appSecretArray[4]);
        adjustConfig.setAppSecret(secretId, info1, info2, info3, info4);
      }
    }

    if (_command.containsParameter('delayStart')) {
      adjustConfig.delayStart = double.parse(_command.getFirstParameterValue('delayStart'));
    }

    if (_command.containsParameter('deviceKnown')) {
      adjustConfig.isDeviceKnown = _command.getFirstParameterValue('deviceKnown') == 'true';
    }

    if (_command.containsParameter('eventBufferingEnabled')) {
      adjustConfig.eventBufferingEnabled = _command.getFirstParameterValue('eventBufferingEnabled') == 'true';
    }

    if (_command.containsParameter('sendInBackground')) {
      adjustConfig.sendInBackground = _command.getFirstParameterValue('sendInBackground') == 'true';
    }

    if (_command.containsParameter('userAgent')) {
      adjustConfig.userAgent = _command.getFirstParameterValue('userAgent');
    }

    // First clear all previous callback handlers.
    adjustConfig.attributionCallback = null;
    adjustConfig.sessionSuccessCallback = null;
    adjustConfig.sessionFailureCallback = null;
    adjustConfig.eventSuccessCallback = null;
    adjustConfig.eventFailureCallback = null;
    adjustConfig.deferredDeeplinkCallback = null;

    // TODO: Deeplinking in Flutter example.
    // https://github.com/flutter/flutter/issues/8711#issuecomment-304681212
    if (_command.containsParameter('deferredDeeplinkCallback')) {
      String localBasePath = _basePath;
      adjustConfig.launchDeferredDeeplink = _command.getFirstParameterValue('deferredDeeplinkCallback') == 'true';
      print('[CommandExecutor]: Deferred deeplink callback, launchDeferredDeeplink: ${adjustConfig.launchDeferredDeeplink}');
      adjustConfig.deferredDeeplinkCallback = (String uri) {
        print('[CommandExecutor]: Sending deeplink info to server: $uri');
        TestLib.addInfoToSend('deeplink', uri);
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('attributionCallbackSendAll')) {
      String localBasePath = _basePath;
      adjustConfig.attributionCallback = (AdjustAttribution attribution) {
        print('[CommandExecutor]: Attribution Callback: $attribution');
        TestLib.addInfoToSend('trackerToken', attribution.trackerToken);
        TestLib.addInfoToSend('trackerName', attribution.trackerName);
        TestLib.addInfoToSend('network', attribution.network);
        TestLib.addInfoToSend('campaign', attribution.campaign);
        TestLib.addInfoToSend('adgroup', attribution.adgroup);
        TestLib.addInfoToSend('creative', attribution.creative);
        TestLib.addInfoToSend('clickLabel', attribution.clickLabel);
        TestLib.addInfoToSend('adid', attribution.adid);
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('sessionCallbackSendSuccess')) {
      String localBasePath = _basePath;
      adjustConfig.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessResponseData) {
        print('[CommandExecutor]: Session Callback Success: $sessionSuccessResponseData');
        TestLib.addInfoToSend('message', sessionSuccessResponseData.message);
        TestLib.addInfoToSend('timestamp', sessionSuccessResponseData.timestamp);
        TestLib.addInfoToSend('adid', sessionSuccessResponseData.adid);
        if (sessionSuccessResponseData.jsonResponse != null) {
            TestLib.addInfoToSend('jsonResponse', sessionSuccessResponseData.jsonResponse);
        }
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('sessionCallbackSendFailure')) {
      String localBasePath = _basePath;
      adjustConfig.sessionFailureCallback = (AdjustSessionFailure sessionFailureResponseData) {
        print('[CommandExecutor]: Session Callback Failure: $sessionFailureResponseData');
        TestLib.addInfoToSend('message', sessionFailureResponseData.message);
        TestLib.addInfoToSend('timestamp', sessionFailureResponseData.timestamp);
        TestLib.addInfoToSend('adid', sessionFailureResponseData.adid);
        TestLib.addInfoToSend('willRetry', sessionFailureResponseData.willRetry.toString());
        if (sessionFailureResponseData.jsonResponse != null) {
            TestLib.addInfoToSend('jsonResponse', sessionFailureResponseData.jsonResponse);
        }
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('eventCallbackSendSuccess')) {
      String localBasePath = _basePath;
      adjustConfig.eventSuccessCallback = (AdjustEventSuccess eventSuccessResponseData) {
        print('[CommandExecutor]: Event Callback Success: $eventSuccessResponseData');
        TestLib.addInfoToSend('message', eventSuccessResponseData.message);
        TestLib.addInfoToSend('timestamp', eventSuccessResponseData.timestamp);
        TestLib.addInfoToSend('adid', eventSuccessResponseData.adid);
        TestLib.addInfoToSend('eventToken', eventSuccessResponseData.eventToken);
        TestLib.addInfoToSend('callbackId', eventSuccessResponseData.callbackId);
        if (eventSuccessResponseData.jsonResponse != null ) {
            TestLib.addInfoToSend('jsonResponse', eventSuccessResponseData.jsonResponse);
        }
        TestLib.sendInfoToServer(localBasePath);
      };
    }

    if (_command.containsParameter('eventCallbackSendFailure')) {
      String localBasePath = _basePath;
      adjustConfig.eventFailureCallback = (AdjustEventFailure eventFailureResponseData) {
        print('[CommandExecutor]: Event Callback Failure: $eventFailureResponseData');
        TestLib.addInfoToSend('message', eventFailureResponseData.message);
        TestLib.addInfoToSend('timestamp', eventFailureResponseData.timestamp);
        TestLib.addInfoToSend('adid', eventFailureResponseData.adid);
        TestLib.addInfoToSend('eventToken', eventFailureResponseData.eventToken);
        TestLib.addInfoToSend('callbackId', eventFailureResponseData.callbackId);
        TestLib.addInfoToSend('willRetry', eventFailureResponseData.willRetry.toString());
        if (eventFailureResponseData.jsonResponse != null) {
            TestLib.addInfoToSend('jsonResponse', eventFailureResponseData.jsonResponse.toString());
        }
        TestLib.sendInfoToServer(localBasePath);
      };
    }
  }

  void _start() {
    _config();
    int configNumber = 0;
    if (_command.containsParameter('configName')) {
      String configName = _command.getFirstParameterValue('configName');
      configNumber = int.parse(configName.substring(configName.length - 1));
    }

    AdjustConfig adjustConfig = _savedConfigs[configNumber];
    Adjust.start(adjustConfig);
    _savedConfigs.remove(configNumber);
  }

  void _event() {
    int eventNumber = 0;
    if (_command.containsParameter('eventNumber')) {
      String eventName = _command.getFirstParameterValue('eventName');
      eventNumber = int.parse(eventName.substring(eventName.length - 1));
    }

    AdjustEvent adjustEvent;
    if (_savedConfigs[eventNumber] != null) {
        adjustEvent = _savedEvents[eventNumber];
    } else {
      String eventToken = _command.getFirstParameterValue('eventToken');
      adjustEvent = new AdjustEvent(eventToken);
      _savedEvents.putIfAbsent(eventNumber, () => adjustEvent);
    }

    if (_command.containsParameter('revenue')) {
      List<dynamic> revenueParams = _command.getParamteters('revenue');
      adjustEvent.setRevenue(num.parse(revenueParams[1]), revenueParams[0]);
    }
    if (_command.containsParameter('callbackParams')) {
      List<dynamic> callbackParams = _command.getParamteters('callbackParams');
      for (int i = 0; i < callbackParams.length; i = i + 2) {
        String key = callbackParams[i];
        String value = callbackParams[i + 1];
        adjustEvent.addCallbackParameter(key, value);
      }
    }
    if (_command.containsParameter('partnerParams')) {
      List<dynamic> partnerParams = _command.getParamteters('partnerParams');
      for (int i = 0; i < partnerParams.length; i = i + 2) {
        String key = partnerParams[i];
        String value = partnerParams[i + 1];
        adjustEvent.addPartnerParameter(key, value);
      }
    }
    if (_command.containsParameter('orderId')) {
      adjustEvent.transactionId = _command.getFirstParameterValue('orderId');
    }
    if (_command.containsParameter('callbackId')) {
      adjustEvent.callbackId = _command.getFirstParameterValue('callbackId');
    }
  }

  void _trackEvent() {
    _event();
    int eventNumber = 0;
    if (_command.containsParameter('eventName')) {
      String eventName = _command.getFirstParameterValue('eventName');
      eventNumber = int.parse(eventName.substring(eventName.length - 1));
    }

    AdjustEvent adjustEvent = _savedEvents[eventNumber];
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
    Adjust.setEnabled(isEnabled);
  }

  void _setReferrer() {
    String referrer = _command.getFirstParameterValue('referrer');
    Adjust.setReferrer(referrer);
  }

  void _setOfflineMode() {
    bool isEnabled = _command.getFirstParameterValue('enabled') == 'true';
    Adjust.setOfflineMode(isEnabled);
  }

  void _sendFirstPackages() {
    Adjust.sendFirstPackages();
  }

  void _setPushToken() {
    String token = _command.getFirstParameterValue('pushToken');
    Adjust.setPushToken(token);
  }

  void _openDeeplink() {
    String deeplink = _command.getFirstParameterValue('deeplink');
    Adjust.appWillOpenUrl(deeplink);
  }

  void _gdprForgetMe() {
    Adjust.gdprForgetMe();
  }

  void _addSessionCallbackParameter() {
    if (!_command.containsParameter('KeyValue')) {
      return;
    }

    List<dynamic> keyValuePairs = _command.getParamteters('KeyValue');
    for (int i = 0; i < keyValuePairs.length; i = i + 2) {
      String key = keyValuePairs[i];
      String value = keyValuePairs[i + 1];
      Adjust.addSessionCallbackParameter(key, value);
    }
  }

  void _addSessionPartnerParameter() {
    if (!_command.containsParameter('KeyValue')) {
      return;
    }

    List<dynamic> keyValuePairs = _command.getParamteters('KeyValue');
    for (int i = 0; i < keyValuePairs.length; i = i + 2) {
      String key = keyValuePairs[i];
      String value = keyValuePairs[i + 1];
      Adjust.addSessionPartnerParameter(key, value);
    }
  }

  void _removeSessionCallbackParameter() {
    if (!_command.containsParameter('key')) {
      return;
    }

    List<dynamic> keys = _command.getParamteters('key');
    for (int i = 0; i < keys.length; i = i + 1) {
      String key = keys[i];
      Adjust.removeSessionCallbackParameter(key);
    }
  }

  void _removeSessionPartnerParameter() {
    if (!_command.containsParameter('key')) {
      return;
    }
    
    List<dynamic> keys = _command.getParamteters('key');
    for (int i = 0; i < keys.length; i = i + 1) {
      String key = keys[i];
      Adjust.removeSessionPartnerParameter(key);
    }
  }

  void _resetSessionCallbackParameters() {
    Adjust.resetSessionCallbackParameters();
  }

  void _resetSessionPartnerParameters() {
    Adjust.resetSessionPartnerParameters();
  }

  void _trackAdRevenue() {
    String source = _command.getFirstParameterValue('adRevenueSource');
    String payload = _command.getFirstParameterValue('adRevenueJsonString');
    Adjust.trackAdRevenue(source, payload);
  }
}
