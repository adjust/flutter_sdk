import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/material.dart';
import 'package:test_app/command.dart';
import 'package:test_app/command_executor.dart';
import 'package:test_lib/test_lib.dart';

void main() {
  runApp(const AdjustTestApp());
}

/// main application widget for Adjust Flutter Test App
class AdjustTestApp extends StatelessWidget {
  const AdjustTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adjust Test App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const TestHomePage(),
    );
  }
}

/// home page containing the test session controls
class TestHomePage extends StatefulWidget {
  const TestHomePage({super.key});

  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  // configuration constants
  static const String _defaultAddress = '192.168.86.211';
  static const String _androidProtocol = 'https';
  static const String _androidPort = '8443';
  static const String _iosProtocol = 'http';
  static const String _iosPort = '8080';
  static const String _wsPort = '1987';

  // adjust brand colors
  static const Color _adjustNavy = Color(0xFF1B2951);
  static const Color _adjustNavyLight = Color(0xFF2A3A5C);

  String? _overwriteUrl;
  late String _controlUrl;
  late CommandExecutor _commandExecutor;

  @override
  void initState() {
    super.initState();
    _initializeTestEnvironment();
  }

  /// initialize the test environment with platform-specific URLs
  void _initializeTestEnvironment() {
    if (Platform.isAndroid) {
      _overwriteUrl = '$_androidProtocol://$_defaultAddress:$_androidPort';
    } else {
      _overwriteUrl = '$_iosProtocol://$_defaultAddress:$_iosPort';
    }
    _controlUrl = 'ws://$_defaultAddress:$_wsPort';

    // initialize command executor
    _commandExecutor = CommandExecutor(_overwriteUrl);

    // initialize test library with command handler
    TestLib.setExecuteCommandHalder(_handleTestCommand);
    TestLib.init(_overwriteUrl!, _controlUrl);
  }

  /// handle incoming test commands
  void _handleTestCommand(dynamic callArgs) {
    print('[AdjustTestApp]: Command handler triggered');
    final command = Command(callArgs);
    print('[AdjustTestApp]: Executing ${command.className}.${command.methodName}');
    _commandExecutor.executeCommand(command);
  }

  /// start a new test session
  void _startTestSession() {
    Adjust.getSdkVersion().then((sdkVersion) {
      print('[AdjustTestApp]: Starting test session with SDK version: $sdkVersion');
      TestLib.startTestSession(sdkVersion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adjust Test App',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: _adjustNavy,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_adjustNavy, _adjustNavyLight],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                 // app icon or logo space
                 Container(
                   width: 80,
                   height: 80,
                   decoration: BoxDecoration(
                     color: Colors.white.withOpacity(0.1),
                     borderRadius: BorderRadius.circular(16),
                   ),
                   child: const Icon(
                     Icons.science_outlined,
                     size: 40,
                     color: Colors.white,
                   ),
                 ),
                 const SizedBox(height: 32),
                 
                 // title and description
                 const Text(
                   'Test Session',
                   style: TextStyle(
                     fontSize: 28,
                     fontWeight: FontWeight.bold,
                     color: Colors.white,
                   ),
                 ),
                 const SizedBox(height: 8),
                 Text(
                   'Tap the button below to start testing\nthe Adjust SDK functionality',
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontSize: 16,
                     color: Colors.white.withOpacity(0.8),
                     height: 1.4,
                   ),
                 ),
                 const SizedBox(height: 48),
                 
                 // main action button
                 _buildStartButton(),
                 
                 const SizedBox(height: 24),
                 
                 // connection info
                 _buildConnectionInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// build the main start test session button
  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _startTestSession,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _adjustNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow_rounded, size: 24),
            SizedBox(width: 8),
            Text(
              'Start Test Session',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// build connection information display
  Widget _buildConnectionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.white.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'Connection Info',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Platform', Platform.isAndroid ? 'Android' : 'iOS'),
          _buildInfoRow('Test URL', _overwriteUrl ?? 'Not set'),
          _buildInfoRow('Control URL', _controlUrl),
        ],
      ),
    );
  }

  /// build an information row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
