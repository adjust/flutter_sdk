import 'dart:async';

import 'package:flutter/services.dart';

typedef void ExecuteCommandHandler(final dynamic callArgs);

class Testlib {
  static const MethodChannel _channel = const MethodChannel('testlib');
  static ExecuteCommandHandler _executeCommandHandler;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void setExecuteCommandHalder(ExecuteCommandHandler handler) {
    _executeCommandHandler = handler;
  }

  static void init(String baseUrl) {
    print(' >>>>> Test Lib Initializing...');
    
    _channel.setMethodCallHandler((MethodCall call) {
      print(' >>>>> INCOMING METHOD FROM NATIVE: ${call.method}');

      try {
        if (call.method == 'execute-method') {
          if (_executeCommandHandler != null) {
            _executeCommandHandler(call.arguments);
          }
        } else {
          print('Unknown method called: ' + call.method);
        }
      } catch (e) {
        print(e.toString());
      }
    });

    _channel.invokeMethod('init', {'baseUrl': baseUrl});
  }

  static void startTestSession(String clientSdk) {
    _channel.invokeMethod('startTestSession', {'clientSdk': clientSdk});
  }

  static void addInfoToSend(String key, String value) {
    _channel.invokeMethod('addInfoToSend', {'key': key, 'value': value});
  }

  static void sendInfoToServer(String basePath) {
    _channel.invokeMethod('sendInfoToServer', {'basePath': basePath});
  }

  static void addTest(String testName) {
    _channel.invokeMethod('addTest', {'testName': testName});
  }

  static void addTestDirectory(String testDirectory) {
    _channel.invokeMethod('addTestDirectory', {'testDirectory': testDirectory});
  }

  static void doNotExitAfterEnd() {
    _channel.invokeMethod('doNotExitAfterEnd');
  }
}
