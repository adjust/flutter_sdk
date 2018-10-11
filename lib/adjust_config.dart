import 'package:adjust_sdk_plugin/nullable.dart';

enum AdjustLogLevel { VERBOSE, DEBUG, INFO, WARN, ERROR, ASSERT, SUPRESS }

enum AdjustEnvironment { production, sandbox }

class AdjustConfig {
  String _sdkPrefix = "flutter4.15.0";
  String appToken;
  String userAgent;
  String defaultTracker;

  Nullable<bool> isDeviceKnown;
  Nullable<bool> sendInBackground;
  Nullable<bool> eventBufferingEnabled;
  Nullable<bool> allowSuppressLogLevel;
  // Nullable<bool> launchDeferredDeeplink;

  AdjustLogLevel logLevel;
  AdjustEnvironment environment;

  Nullable<num> info1;
  Nullable<num> info2;
  Nullable<num> info3;
  Nullable<num> info4;
  Nullable<num> secretId;

  Nullable<double> delayStart;

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
    this.secretId = new Nullable<num>(secretId);
    this.info1 = new Nullable<num>(info1);
    this.info2 = new Nullable<num>(info2);
    this.info3 = new Nullable<num>(info3);
    this.info4 = new Nullable<num>(info4);
  }

  Map<String, String> get configParamsMap {
    Map<String, String> configParamsMap = {
      'sdkPrefix': _sdkPrefix,
      'appToken': appToken,
      'environment': environmentString,
      'userAgent': 'flutter',
    };

    if (logLevelString != null) {
      configParamsMap['logLevel'] = logLevelString;
    }
    if (defaultTracker != null) {
      configParamsMap['defaultTracker'] = defaultTracker;
    }
    if (isDeviceKnown != null) {
      configParamsMap['isDeviceKnown'] = isDeviceKnown.strValue;
    }
    if (sendInBackground != null) {
      configParamsMap['sendInBackground'] = sendInBackground.strValue;
    }
    if (eventBufferingEnabled != null) {
      configParamsMap['eventBufferingEnabled'] = eventBufferingEnabled.strValue;
    }
    if (allowSuppressLogLevel != null) {
      configParamsMap['allowSuppressLogLevel'] = allowSuppressLogLevel.strValue;
    }
    if (info1 != null) {
      configParamsMap['info1'] = info1.strValue;
    }
    if (info2 != null) {
      configParamsMap['info2'] = info2.strValue;
    }
    if (info3 != null) {
      configParamsMap['info3'] = info3.strValue;
    }
    if (info4 != null) {
      configParamsMap['info4'] = info4.strValue;
    }
    if (secretId != null) {
      configParamsMap['secretId'] = secretId.strValue;
    }
    if (delayStart != null) {
      configParamsMap['delayStart'] = delayStart.strValue;
    }
    
    return configParamsMap;
  }
}
