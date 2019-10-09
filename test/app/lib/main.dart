import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_lib/test_lib.dart';
import 'package:test_app/command.dart';
import 'package:test_app/command_executor.dart';
import 'package:adjust_sdk/adjust.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _baseUrl;
  String _controlUrl;
  String _gdprUrl;
  CommandExecutor _commandExecutor;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    String _address = '192.168.8.222';
    if (Platform.isAndroid) {
      String _protocol = 'https';
      String _port = '8443';
      _baseUrl = _protocol + '://' + _address + ':' + _port;
      _gdprUrl = _protocol + '://' + _address + ':' + _port;
    } else {
      String _protocol = 'http';
      String _port = '8000';
      _baseUrl = _protocol + '://' + _address + ':' + _port;
      _gdprUrl = _protocol + '://' + _address + ':' + _port;
    }
    _controlUrl = 'ws://' + _address + ':1987';

    // Initialise command executor.
    _commandExecutor = new CommandExecutor(_baseUrl, _gdprUrl);

    // Initialise test library.
    TestLib.init(_baseUrl, _controlUrl);
    TestLib.doNotExitAfterEnd();
    TestLib.setExecuteCommandHalder((final dynamic callArgs) {
      Command command = new Command(callArgs);
      print('[AdjustTestApp]: Executing command ${command.className}.${command.methodName}');
      _commandExecutor.executeCommand(command);
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await TestLib.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Adjust Flutter SDK Test App'),
        ),
        body: new CustomScrollView(shrinkWrap: true, slivers: <Widget>[
          new SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                new Text('Running'),
                buildCupertinoButton(
                    'Start Test Session',
                    () => Adjust.getSdkVersion().then((sdkVersion) {
                      TestLib.startTestSession(sdkVersion);
                    }))
              ])))
        ]),
      ),
    );
  }

  static Widget buildCupertinoButton(String text, Function action) {
    return new CupertinoButton(
      child: Text(text),
      color: CupertinoColors.activeBlue,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
      onPressed: action,
    );
  }
}
