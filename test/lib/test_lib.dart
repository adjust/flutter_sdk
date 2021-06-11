//
//  test_lib.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-2021 Adjust GmbH. All rights reserved.
//

import 'package:flutter/services.dart';

typedef void ExecuteCommandHandler(final dynamic callArgs);

class TestLib {
  static const MethodChannel _channel = const MethodChannel('com.adjust.test.lib/api');
  static ExecuteCommandHandler? _executeCommandHandler;

  static void setExecuteCommandHalder(ExecuteCommandHandler handler) {
    _executeCommandHandler = handler;
    _channel.setMethodCallHandler((MethodCall call) async {
      try {
        switch (call.method) {
          case 'adj-test-execute':
            if (_executeCommandHandler != null) {
              _executeCommandHandler!(call.arguments);
            }
            break;
          default:
            throw new UnsupportedError('[TestLibrary]: Received unknown native method: ${call.method}');
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  static void init(String baseUrl, String controlUrl) {
    _channel.invokeMethod('init', {'baseUrl': baseUrl, 'controlUrl': controlUrl});
  }

  static void startTestSession(String clientSdk) {
    _channel.invokeMethod('startTestSession', {'clientSdk': clientSdk});
  }

  static void addInfoToSend(String key, String? value) {
    if (value == null) {
      print('[TestLibrary]: Skip adding info to server for key [$key]. Value is null.');
      return;
    }
    _channel.invokeMethod('addInfoToSend', {'key': key, 'value': value});
  }

  static void sendInfoToServer(String? basePath) {
    if (basePath == null) {
      print('[TestLibrary]: Skip sending info to server with base path set to null.');
      return;
    }
    _channel.invokeMethod('sendInfoToServer', {'basePath': basePath});
  }

  static void addTest(String? testName) {
    if (testName == null) {
      print('[TestLibrary]: Skip adding test with null value for the name.');
      return;
    }
    _channel.invokeMethod('addTest', {'testName': testName});
  }

  static void addTestDirectory(String? testDirectory) {
    if (testDirectory == null) {
      print('[TestLibrary]: Skip adding test directory with null value for the name.');
      return;
    }
    _channel.invokeMethod('addTestDirectory', {'testDirectory': testDirectory});
  }

  static void doNotExitAfterEnd() {
    _channel.invokeMethod('doNotExitAfterEnd');
  }

  static void setTestConnectionOptions() {
    _channel.invokeMethod('setTestConnectionOptions');
  }
}
