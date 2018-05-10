enum AdjustLogLevel { VERBOSE, DEBUG, INFO, WARN, ERROR, ASSERT, SUPRESS }

enum AdjustEnvironment { production, sandbox }

class AdjustConfig {
  String appToken;
  String userAgent;
  String defaultTracker;

  bool isDeviceKnown;
  bool sendInBackground;
  bool eventBufferingEnabled;
  bool allowSuppressLogLevel;
  // bool launchDeferredDeeplink;

  AdjustLogLevel logLevel;
  AdjustEnvironment environment;

  num info1;
  num info2;
  num info3;
  num info4;
  num secretId;

  double delayStart;

  // Android specific members
  String processName;
  bool readImei;

  String get environmentString {
    return environment
        .toString()
        .substring(environment.toString().indexOf('.') + 1);
  }

  String get logLevelString {
    return logLevel.toString().substring(logLevel.toString().indexOf('.') + 1);
  }

  void setAppSecret(num secretId, num info1, num info2, num info3, num info4) {
    this.secretId = secretId;
    this.info1 = info1;
    this.info2 = info2;
    this.info3 = info3;
    this.info4 = info4;
  }

  Map<String, String> get configParamsMap {
    return {
      'appToken': appToken,
      'environment': environmentString,
      'logLevel': logLevelString,
      'userAgent': 'flutter',
      'defaultTracker': defaultTracker,
      'isDeviceKnown': isDeviceKnown.toString(),
      'sendInBackground': sendInBackground.toString(),
      'eventBufferingEnabled': eventBufferingEnabled.toString(),
      'allowSuppressLogLevel': allowSuppressLogLevel.toString(),
      'info1': info1.toString(),
      'info2': info2.toString(),
      'info3': info3.toString(),
      'info4': info4.toString(),
      'secretId': secretId.toString(),
      'delayStart': delayStart.toString(),
      'readImei': readImei.toString(),
    };
  }
}
