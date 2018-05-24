import 'package:adjust_sdk_plugin/adjust_config.dart';
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
          //TODO: not needed actually ??
          break;
        case AppLifecycleState.resumed:
          AdjustSdkPlugin.onResume();
          break;
        case AppLifecycleState.paused:
          AdjustSdkPlugin.onPause();
          break;
        case AppLifecycleState.suspending:
          //TODO: not needed actually ??
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

    // Set default tracker
    // config.defaultTracker = "def_tracker";

    // Set process name.
    // config.processName = "com.adjust.examples";

    // Allow to send in the background.
    config.sendInBackground = true;

    // Enable event buffering.
    // config.eventBufferingEnabled = true;

    // Delay first session.
    // config.delayStart = 7.0;

    // Add session callback parameters.
    AdjustSdkPlugin.addSessionCallbackParameter("scp_foo_1", "scp_bar");
    AdjustSdkPlugin.addSessionCallbackParameter("scp_foo_2", "scp_value");

    // Add session Partner parameters.
    AdjustSdkPlugin.addSessionPartnerParameter("scp_foo_1", "scp_bar");
    AdjustSdkPlugin.addSessionPartnerParameter("scp_foo_2", "scp_value");

    // Remove session callback parameters.
    AdjustSdkPlugin.removeSessionCallbackParameter("scp_foo_1");
    AdjustSdkPlugin.removeSessionPartnerParameter("scp_foo_1");

    // Clear all session callback parameters.
    AdjustSdkPlugin.resetSessionCallbackParameters();

    // Clear all session partner parameters.
    AdjustSdkPlugin.resetSessionPartnerParameters();

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
            title: new Text('Example App using Adjust Flutter SDK'),
          ),
          body: new CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              new SliverPadding(
                padding: const EdgeInsets.all(20.0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      new Text('Running on: $_platformVersion\n'),
                      _lastLifecycleState == null
                          ? const Text(
                              'This widget has not observed any lifecycle changes.')
                          : new Text(
                              'The most recent lifecycle state this widget observed was: $_lastLifecycleState.'),

                      Util.buildRaisedButtonRow(
                          'Is Enabled ?', () => _showIsSdkEnabled(context)),

                      // track simple event button
                      Util.buildRaisedButtonRow(
                          'Track Sample Event',
                          () => AdjustSdkPlugin
                              .trackEvent(Util.buildSimpleEvent())),

                      // track revenue event button
                      Util.buildRaisedButtonRow(
                          'Track Revenue Event',
                          () => AdjustSdkPlugin
                              .trackEvent(Util.buildRevenueEvent())),

                      // track callback event button
                      Util.buildRaisedButtonRow(
                          'Track Callback Event',
                          () => AdjustSdkPlugin
                              .trackEvent(Util.buildCallbackEvent())),

                      // track partner event button
                      Util.buildRaisedButtonRow(
                          'Track Partner Event',
                          () => AdjustSdkPlugin
                              .trackEvent(Util.buildPartnerEvent())),

                      // get google AdId
                      Util.buildRaisedButtonRow(
                          'Get Google AdId',
                          () => AdjustSdkPlugin
                                  .getGoogleAdId()
                                  .then((googleAdid) {
                                print('Received google AdId: $googleAdid');
                              })),

                      // get ADID (Android)
                      Util.buildRaisedButtonRow(
                          'Get ADID (Android)',
                          () => AdjustSdkPlugin.getAdid().then((adid) {
                                print('Received ADID: $adid');
                              })),

                      // get IDFA (iOS)
                      Util.buildRaisedButtonRow(
                          'Get IDFA (iOS)',
                          () => AdjustSdkPlugin.getIdfa().then((idfa) {
                                print('Received IDFA: $idfa');
                              })),

                      // get attribution
                      Util.buildRaisedButtonRow(
                          'Get Attribution',
                          () => AdjustSdkPlugin
                                  .getAttribution()
                                  .then((attribution) {
                                print(
                                    'Received attribution: ${attribution.toString()}');
                              })),

                      // SDK enabled/disabled switch
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // is SDK enabled switch
                          new Text(
                            _isSdkEnabled ? 'Enabled' : 'Disabled',
                            style: _isSdkEnabled
                                ? new TextStyle(
                                    fontSize: 32.0, color: Colors.green)
                                : new TextStyle(
                                    fontSize: 32.0, color: Colors.red),
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

                      // end
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _showIsSdkEnabled(BuildContext context) {
    try {
      AdjustSdkPlugin.isEnabled().then((isEnabled) {
        String message = 'Adjust is enabled = $isEnabled';
        print(message);
        // Util.showMessage(context, 'SDK Enabled?', message);
      });
    } on PlatformException {
      print('no such method found im plugin: isEnabled');
      // Util.showMessage(context, 'SDK Enabled?',
      // 'Error - no such method found im plugin: isEnabled');
    }
  }

  _setCallbacks() {
    AdjustSdkPlugin
        .setSessionSuccessHandler((AdjustSessionSuccess sessionSuccessData) {
      print(' >>>> Reeceived sessionSuccessData: ' +
          sessionSuccessData.toString());
    });

    AdjustSdkPlugin
        .setSessionFailureHandler((AdjustSessionFailure sessionFailureData) {
      print(' >>>> Reeceived sessionFailureData: ' +
          sessionFailureData.toString());
    });

    AdjustSdkPlugin
        .setEventSuccessHandler((AdjustEventSuccess eventSuccessData) {
      print(' >>>> Reeceived eventFailureData: ' + eventSuccessData.toString());
    });

    AdjustSdkPlugin
        .setEventFailureHandler((AdjustEventFailure eventFailureData) {
      print(' >>>> Reeceived eventFailureData: ' + eventFailureData.toString());
    });

    AdjustSdkPlugin.setAttributionChangedHandler(
        (AdjustAttribution attributionChangedData) {
      print(' >>>> Reeceived attributionChangedData: ' +
          attributionChangedData.toString());
    });

    AdjustSdkPlugin.setShouldLaunchReceivedDeeplinkHandler((String uri) {
      if (uri.startsWith('adjust.')) {
        return true;
      }
      return false;
    });
  }
}
