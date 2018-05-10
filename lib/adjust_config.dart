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
  bool launchDeferredDeeplink;

  AdjustLogLevel logLevel;
  AdjustEnvironment environment;

  // example of platform calling the client codebase:
  // https://github.com/flutter/plugins/tree/master/packages/quick_actions

  //  Action<string> deferredDeeplinkDelegate;
  //  Action<AdjustEventSuccess> eventSuccessDelegate;
  //  Action<AdjustEventFailure> eventFailureDelegate;
  //  Action<AdjustSessionSuccess> sessionSuccessDelegate;
  //  Action<AdjustSessionFailure> sessionFailureDelegate;
  //  Action<AdjustAttribution> attributionChangedDelegate;

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

  Map<String, String> get configParamsMap {
    return {
      'appToken': appToken,
      'environment': environmentString,
      'logLevel': logLevelString,
      'userAgent': 'flutter',
      'defaultTracker': defaultTracker,
      'isDeviceKnown': isDeviceKnown.toString(),
    };
  }
}
