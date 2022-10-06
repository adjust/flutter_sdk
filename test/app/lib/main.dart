import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/command.dart';
import 'package:test_app/command_executor.dart';
import 'package:test_lib/test_lib.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _baseUrl;
  String? _gdprUrl;
  String? _subscriptionUrl;
  late String _controlUrl;
  late CommandExecutor _commandExecutor;

  @override
  void initState() {
    super.initState();

    String _address = '192.168.86.44';
    if (Platform.isAndroid) {
      String _protocol = 'https';
      String _port = '8443';
      _baseUrl = _protocol + '://' + _address + ':' + _port;
      _gdprUrl = _protocol + '://' + _address + ':' + _port;
      _subscriptionUrl = _protocol + '://' + _address + ':' + _port;
      _controlUrl = 'ws://' + _address + ':1987';
    } else {
      String _protocol = 'http';
      String _port = '8080';
      _baseUrl = _protocol + '://' + _address + ':' + _port;
      _gdprUrl = _protocol + '://' + _address + ':' + _port;
      _subscriptionUrl = _protocol + '://' + _address + ':' + _port;
      _controlUrl = 'ws://' + _address + ':1987';
    }

    // Initialise command executor.
    _commandExecutor =
        new CommandExecutor(_baseUrl, _gdprUrl, _subscriptionUrl);

    // Initialise test library.
    TestLib.setExecuteCommandHalder((final dynamic callArgs) {
      print('[AdjustTestApp]: executeCommandHandler pinged in test app!');
      Command command = new Command(callArgs);
      print(
          '[AdjustTestApp]: Executing command ${command.className}.${command.methodName}');
      _commandExecutor.executeCommand(command);
    });
    TestLib.init(_baseUrl!, _controlUrl);
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
                          TestLib.addTestDirectory('third-party-sharing');
                          // TestLib.addTest('Test_Event_Revenue_invalid');
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
      onPressed: action as void Function()?,
    );
  }
}
