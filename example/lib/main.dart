import 'package:adjust_sdk_plugin/adjust_config.dart';
import 'package:adjust_sdk_plugin/adjust_event.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjust_attribution.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjust_event_failure.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjust_event_success.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjust_session_failure.dart';
import 'package:adjust_sdk_plugin/callbacksData/adjust_session_success.dart';
import 'package:adjust_sdk_plugin_example/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adjust_sdk_plugin/adjust_sdk_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _platformVersion = 'Unknown';
  AppLifecycleState _lastLifecycleState;
  bool _isSdkEnabled = true;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    initPlatformState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.inactive:
          //TODO:
          break;
        case AppLifecycleState.resumed:
          AdjustSdkPlugin.onResume();
          break;
        case AppLifecycleState.paused:
          AdjustSdkPlugin.onPause();
          break;
        case AppLifecycleState.suspending:
          //TODO:
          break;
      }

      _lastLifecycleState = state;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    AdjustConfig config = new AdjustConfig();
    config.appToken = "2fm9gkqubvpc";
    config.environment = AdjustEnvironment.sandbox;
    config.logLevel = AdjustLogLevel.VERBOSE;
    config.isDeviceKnown = false;
    //config.defaultTracker = "";

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AdjustSdkPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // initialize the Adjust SDK
    print('Calling Adjust onCreate...');
    AdjustSdkPlugin.onCreate(config);

    // set callbacks for session, event, attribution and deeplink
    _setCallbacks();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;

      // start the Adjust SDK
      AdjustSdkPlugin.onResume();

      // ask if enabled
      AdjustSdkPlugin.isEnabled().then((isEnabled) {
        _isSdkEnabled = isEnabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Column(
          children: <Widget>[
            new Text('Running on: $_platformVersion\n'),
            _lastLifecycleState == null
                ? const Text(
                    'This widget has not observed any lifecycle changes.')
                : new Text(
                    'The most recent lifecycle state this widget observed was: $_lastLifecycleState.'),

            Util.buildRasedButtonRow('Is Enabled ?', () => _printIsSdkEnabled()),

            // track simple event button
            Util.buildRasedButtonRow(
                'Track Sample Event',
                () => AdjustSdkPlugin
                    .trackEvent(new AdjustEvent('c4thih', 10, 'EUR', ''))),

            // get google AdId
            Util.buildRasedButtonRow(
                'Get Google AdId',
                () => AdjustSdkPlugin.getGoogleAdId().then((googleAdid) {
                      print('Received google AdId: $googleAdid');
                    })),

            // get ADID
            Util.buildRasedButtonRow(
                'Get ADID',
                () => AdjustSdkPlugin.getAdid().then((adid) {
                      print('Received ADID: $adid');
                    })),

            // get attribution
            Util.buildRasedButtonRow('Get Attribution',
                () => AdjustSdkPlugin.getAttribution().then((attribution) {
                  print('Received attribution: ${attribution.toString()}');
                })),

            // is SDK enabled switch
            new Text(
              _isSdkEnabled ? 'Enabled' : 'Disabled',
              style: _isSdkEnabled
                  ? new TextStyle(fontSize: 32.0, color: Colors.green)
                  : new TextStyle(fontSize: 32.0, color: Colors.red),
            ),
            new CupertinoSwitch(
              value: _isSdkEnabled,
              onChanged: (bool value) {
                setState(() {
                  AdjustSdkPlugin.setIsEnabled(value);
                  _isSdkEnabled = value;
                  print('switch state = $_isSdkEnabled');
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _printIsSdkEnabled() {
    try {
      AdjustSdkPlugin.isEnabled().then((isEnabled) {
        print('Adjust is enabled = $isEnabled');
      });
    } on PlatformException {
      print('no such method found im plugin: isEnabled');
    }
  }

  _setCallbacks() {
    AdjustSdkPlugin
        .setSessionSuccessHandler((AdjustSessionSuccess sessionSuccessData) {
      print(
          ' >>>> Reeceived sessionSuccessData: ' + sessionSuccessData.message);
    });

    AdjustSdkPlugin
        .setSessionFailureHandler((AdjustSessionFailure sessionFailureData) {
      print(
          ' >>>> Reeceived sessionFailureData: ' + sessionFailureData.message);
    });

    AdjustSdkPlugin
        .setEventSuccessHandler((AdjustEventSuccess eventSuccessData) {
      print(' >>>> Reeceived eventFailureData: ' + eventSuccessData.message);
    });

    AdjustSdkPlugin
        .setEventFailureHandler((AdjustEventFailure eventFailureData) {
      print(' >>>> Reeceived eventFailureData: ' + eventFailureData.message);
    });

    AdjustSdkPlugin.setAttributionChangedHandler(
        (AdjustAttribution attributionChangedData) {
      print(' >>>> Reeceived attributionChangedData: ' +
          attributionChangedData.trackerToken);
    });

    AdjustSdkPlugin.setShouldLaunchReceivedDeeplinkHandler((String uri) {
      if (uri.startsWith('adjust.')) {
        return true;
      }
      return false;
    });
  }
}
