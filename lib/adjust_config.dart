import 'package:adjust_sdk_plugin/nullable.dart';

enum AdjustLogLevel { VERBOSE, DEBUG, INFO, WARN, ERROR, ASSERT, SUPRESS }

enum AdjustEnvironment { production, sandbox }

class AdjustConfig {
  String _sdkPrefix = "flutter4.16.0";
  String appToken;
  String userAgent;
  String defaultTracker;

  Nullable<bool> _isDeviceKnown;
  Nullable<bool> _sendInBackground;
  Nullable<bool> _eventBufferingEnabled;
  Nullable<bool> _allowSuppressLogLevel;
  Nullable<bool> _launchDeferredDeeplink;

  AdjustLogLevel logLevel;
  AdjustEnvironment environment;

  Nullable<num> _info1;
  Nullable<num> _info2;
  Nullable<num> _info3;
  Nullable<num> _info4;
  Nullable<num> _secretId;

  Nullable<double> _delayStart;

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
    _secretId = new Nullable<num>(secretId);
    _info1 = new Nullable<num>(info1);
    _info2 = new Nullable<num>(info2);
    _info3 = new Nullable<num>(info3);
    _info4 = new Nullable<num>(info4);
  }

  get isDeviceKnown => _isDeviceKnown != null ? _isDeviceKnown.value : null;
  set isDeviceKnown(bool isDeviceKnown) {
    _isDeviceKnown = new Nullable<bool>(isDeviceKnown);
  }

  set sendInBackground(bool sendInBackground) {
    _sendInBackground = new Nullable<bool>(sendInBackground);
  }

  set eventBufferingEnabled(bool eventBufferingEnabled) {
    _eventBufferingEnabled = new Nullable<bool>(eventBufferingEnabled);
  }

  set allowSuppressLogLevel(bool allowSuppressLogLevel) {
    _allowSuppressLogLevel = new Nullable<bool>(allowSuppressLogLevel);
  }

  get launchDeferredDeeplink => _launchDeferredDeeplink.value;
  set launchDeferredDeeplink(bool launchDeferredDeeplink) {
    _launchDeferredDeeplink = new Nullable<bool>(launchDeferredDeeplink);
  }

  set delayStart(double delayStart) {
    _delayStart = new Nullable<double>(delayStart);
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
    if (_isDeviceKnown != null) {
      configParamsMap['isDeviceKnown'] = _isDeviceKnown.strValue;
    }
    if (_sendInBackground != null) {
      configParamsMap['sendInBackground'] = _sendInBackground.strValue;
    }
    if (_eventBufferingEnabled != null) {
      configParamsMap['eventBufferingEnabled'] = _eventBufferingEnabled.strValue;
    }
    if (_allowSuppressLogLevel != null) {
      configParamsMap['allowSuppressLogLevel'] = _allowSuppressLogLevel.strValue;
    }
    if (_launchDeferredDeeplink != null) {
      configParamsMap['launchDeferredDeeplink'] = _launchDeferredDeeplink.strValue;
    }
    if (_info1 != null) {
      configParamsMap['info1'] = _info1.strValue;
    }
    if (_info2 != null) {
      configParamsMap['info2'] = _info2.strValue;
    }
    if (_info3 != null) {
      configParamsMap['info3'] = _info3.strValue;
    }
    if (_info4 != null) {
      configParamsMap['info4'] = _info4.strValue;
    }
    if (_secretId != null) {
      configParamsMap['secretId'] = _secretId.strValue;
    }
    if (_delayStart != null) {
      configParamsMap['delayStart'] = _delayStart.strValue;
    }
    
    return configParamsMap;
  }
}
