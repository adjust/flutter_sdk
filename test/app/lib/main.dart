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
  String? _overwriteUrl;
  late String _controlUrl;
  late CommandExecutor _commandExecutor;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      String _address = '192.168.86.237';
      String _protocol = 'https';
      String _port = '8443';
      _overwriteUrl = _protocol + '://' + _address + ':' + _port;
      _controlUrl = 'ws://' + _address + ':1987';
    } else {
      String _address = '192.168.86.237';
      String _protocol = 'http';
      String _port = '8080';
      _overwriteUrl = _protocol + '://' + _address + ':' + _port;
      _controlUrl = 'ws://' + _address + ':1987';
    }

    // Initialise command executor.
    _commandExecutor =
        new CommandExecutor(_overwriteUrl);

    // Initialise test library.
    TestLib.setExecuteCommandHalder((final dynamic callArgs) {
      print('[AdjustTestApp]: executeCommandHandler pinged in test app!');
      Command command = new Command(callArgs);
      print(
          '[AdjustTestApp]: Executing command ${command.className}.${command.methodName}');
      _commandExecutor.executeCommand(command);
    });
    TestLib.init(_overwriteUrl!, _controlUrl);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adjust Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Adjust Test App'),
          centerTitle: true,
          backgroundColor: const Color(0xFF1B2951), // Adjust dark navy color
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1B2951), // Adjust dark navy
                Color(0xFF2A3A5C), // Slightly lighter navy
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildActionButton(
                'Start Test Session',
                () => Adjust.getSdkVersion().then((sdkVersion) {
                  TestLib.startTestSession(sdkVersion);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1B2951),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 3,
          shadowColor: Colors.black26,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
