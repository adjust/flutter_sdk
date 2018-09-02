import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:testlib/testlib.dart';
import 'package:testlib_example/command.dart';

import 'package:adjust_sdk_plugin/adjust_sdk_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _baseUrl = "https://10.0.2.2:8443";
  String _gdprUrl = "https://10.0.2.2:8443";

  @override
  void initState() {
    super.initState();
    initPlatformState();

    // init test library
    Testlib.init(_baseUrl);

    Testlib.setExecuteCommandHalder((final dynamic callArgs) {
      Command command = Command.fromMap(callArgs);
      print('>>> EXECUTING METHOD: [${command.className}.${command.methodName}] <<<');

      // example of using Adjust Flutter SDK Plugin
      AdjustSdkPlugin.onCreate(null);
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Testlib.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Flutter test app'),
        ),
        body: new CustomScrollView(shrinkWrap: true, slivers: <Widget>[
          new SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                new Text('Running on: $_platformVersion\n'),
                buildCupertinoButton('Start Test Session',
                    () => Testlib.startTestSession('flutter'))
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
