enum AdjustLogLevel { VERBOSE, DEBUG, INFO, WARN, ERROR, ASSERT, SUPRESS }

enum AdjustEnvironment { production, sandbox }

class AdjustConfig {
  String _sdkPrefix = "flutter4.16.0";
  String appToken;
  String userAgent;
  String defaultTracker;

  bool isDeviceKnown;
  bool sendInBackground;
  bool eventBufferingEnabled;
  bool allowSuppressLogLevel;
  bool launchDeferredDeeplink;

  AdjustLogLevel logLevel;
  AdjustEnvironment environment;

  num _info1;
  num _info2;
  num _info3;
  num _info4;
  num _secretId;

  double delayStart;

  // Android specific members
  String processName;
  
  AdjustConfig(this.appToken, this.environment);

  String get environmentString {
    return environment
        .toString()
        .substring(environment.toString().indexOf('.') + 1);
  }

  String get logLevelString {
    return logLevel.toString().substring(logLevel.toString().indexOf('.') + 1);
  }

  void setAppSecret(num secretId, num info1, num info2, num info3, num info4) {
    _secretId = secretId;
    _info1 = info1;
    _info2 = info2;
    _info3 = info3;
    _info4 = info4;
  }

  Map<String, String> get configParamsMap {
    Map<String, String> configParamsMap = {
      'sdkPrefix': _sdkPrefix,
      'appToken': appToken,
      'environment': environmentString,
    };

    if (userAgent != null) {
      configParamsMap['userAgent'] = userAgent;
    }
    if (logLevelString != null) {
      configParamsMap['logLevel'] = logLevelString;
    }
    if (defaultTracker != null) {
      configParamsMap['defaultTracker'] = defaultTracker;
    }
    if (isDeviceKnown != null) {
      configParamsMap['isDeviceKnown'] = isDeviceKnown.toString();
    }
    if (sendInBackground != null) {
      configParamsMap['sendInBackground'] = sendInBackground.toString();
    }
    if (eventBufferingEnabled != null) {
      configParamsMap['eventBufferingEnabled'] = eventBufferingEnabled.toString();
    }
    if (allowSuppressLogLevel != null) {
      configParamsMap['allowSuppressLogLevel'] = allowSuppressLogLevel.toString();
    }
    if (launchDeferredDeeplink != null) {
      configParamsMap['launchDeferredDeeplink'] = launchDeferredDeeplink.toString();
    }
    if (_info1 != null) {
      configParamsMap['info1'] = _info1.toString();
    }
    if (_info2 != null) {
      configParamsMap['info2'] = _info2.toString();
    }
    if (_info3 != null) {
      configParamsMap['info3'] = _info3.toString();
    }
    if (_info4 != null) {
      configParamsMap['info4'] = _info4.toString();
    }
    if (_secretId != null) {
      configParamsMap['secretId'] = _secretId.toString();
    }
    if (delayStart != null) {
      configParamsMap['delayStart'] = delayStart.toString();
    }
    
    return configParamsMap;
  }
}
