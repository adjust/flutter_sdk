import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _isSdkEnabled = true;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    initPlatformState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    AdjustConfig config = new AdjustConfig('2fm9gkqubvpc', AdjustEnvironment.sandbox);
    config.logLevel = AdjustLogLevel.verbose;
    config.urlStrategy = AdjustConfig.DataResidencyUS;

    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      print('[Adjust]: Attribution changed!');

      if (attributionChangedData.trackerToken != null) {
        print('[Adjust]: Tracker token: ' + attributionChangedData.trackerToken!);
      }
      if (attributionChangedData.trackerName != null) {
        print('[Adjust]: Tracker name: ' + attributionChangedData.trackerName!);
      }
      if (attributionChangedData.campaign != null) {
        print('[Adjust]: Campaign: ' + attributionChangedData.campaign!);
      }
      if (attributionChangedData.network != null) {
        print('[Adjust]: Network: ' + attributionChangedData.network!);
      }
      if (attributionChangedData.creative != null) {
        print('[Adjust]: Creative: ' + attributionChangedData.creative!);
      }
      if (attributionChangedData.adgroup != null) {
        print('[Adjust]: Adgroup: ' + attributionChangedData.adgroup!);
      }
      if (attributionChangedData.clickLabel != null) {
        print('[Adjust]: Click label: ' + attributionChangedData.clickLabel!);
      }
      if (attributionChangedData.adid != null) {
        print('[Adjust]: Adid: ' + attributionChangedData.adid!);
      }
      if (attributionChangedData.costType != null) {
        print('[Adjust]: Cost type: ' + attributionChangedData.costType!);
      }
      if (attributionChangedData.costAmount != null) {
        print('[Adjust]: Cost amount: ' + attributionChangedData.costAmount!.toString());
      }
      if (attributionChangedData.costCurrency != null) {
        print('[Adjust]: Cost currency: ' + attributionChangedData.costCurrency!);
      }
    };

    config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
      print('[Adjust]: Session tracking success!');

      if (sessionSuccessData.message != null) {
        print('[Adjust]: Message: ' + sessionSuccessData.message!);
      }
      if (sessionSuccessData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + sessionSuccessData.timestamp!);
      }
      if (sessionSuccessData.adid != null) {
        print('[Adjust]: Adid: ' + sessionSuccessData.adid!);
      }
      if (sessionSuccessData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + sessionSuccessData.jsonResponse!);
      }
    };

    config.sessionFailureCallback = (AdjustSessionFailure sessionFailureData) {
      print('[Adjust]: Session tracking failure!');

      if (sessionFailureData.message != null) {
        print('[Adjust]: Message: ' + sessionFailureData.message!);
      }
      if (sessionFailureData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + sessionFailureData.timestamp!);
      }
      if (sessionFailureData.adid != null) {
        print('[Adjust]: Adid: ' + sessionFailureData.adid!);
      }
      if (sessionFailureData.willRetry != null) {
        print('[Adjust]: Will retry: ' + sessionFailureData.willRetry.toString());
      }
      if (sessionFailureData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + sessionFailureData.jsonResponse!);
      }
    };

    config.eventSuccessCallback = (AdjustEventSuccess eventSuccessData) {
      print('[Adjust]: Event tracking success!');

      if (eventSuccessData.eventToken != null) {
        print('[Adjust]: Event token: ' + eventSuccessData.eventToken!);
      }
      if (eventSuccessData.message != null) {
        print('[Adjust]: Message: ' + eventSuccessData.message!);
      }
      if (eventSuccessData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + eventSuccessData.timestamp!);
      }
      if (eventSuccessData.adid != null) {
        print('[Adjust]: Adid: ' + eventSuccessData.adid!);
      }
      if (eventSuccessData.callbackId != null) {
        print('[Adjust]: Callback ID: ' + eventSuccessData.callbackId!);
      }
      if (eventSuccessData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + eventSuccessData.jsonResponse!);
      }
    };

    config.eventFailureCallback = (AdjustEventFailure eventFailureData) {
      print('[Adjust]: Event tracking failure!');

      if (eventFailureData.eventToken != null) {
        print('[Adjust]: Event token: ' + eventFailureData.eventToken!);
      }
      if (eventFailureData.message != null) {
        print('[Adjust]: Message: ' + eventFailureData.message!);
      }
      if (eventFailureData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + eventFailureData.timestamp!);
      }
      if (eventFailureData.adid != null) {
        print('[Adjust]: Adid: ' + eventFailureData.adid!);
      }
      if (eventFailureData.callbackId != null) {
        print('[Adjust]: Callback ID: ' + eventFailureData.callbackId!);
      }
      if (eventFailureData.willRetry != null) {
        print('[Adjust]: Will retry: ' + eventFailureData.willRetry.toString());
      }
      if (eventFailureData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + eventFailureData.jsonResponse!);
      }
    };

    config.deferredDeeplinkCallback = (String? uri) {
      print('[Adjust]: Received deferred deeplink: ' + uri!);
    };

    config.conversionValueUpdatedCallback = (num? conversionValue) {
      print('[Adjust]: Received conversion value update: ' + conversionValue!.toString());
    };

    // Add session callback parameters.
    Adjust.addSessionCallbackParameter('scp_foo_1', 'scp_bar');
    Adjust.addSessionCallbackParameter('scp_foo_2', 'scp_value');

    // Add session Partner parameters.
    Adjust.addSessionPartnerParameter('spp_foo_1', 'spp_bar');
    Adjust.addSessionPartnerParameter('spp_foo_2', 'spp_value');

    // Remove session callback parameters.
    Adjust.removeSessionCallbackParameter('scp_foo_1');
    Adjust.removeSessionPartnerParameter('spp_foo_1');

    // Clear all session callback parameters.
    Adjust.resetSessionCallbackParameters();

    // Clear all session partner parameters.
    Adjust.resetSessionPartnerParameters();

    // Ask for tracking consent.
    Adjust.requestTrackingAuthorizationWithCompletionHandler().then((status) {
      print('[Adjust]: Authorization status update!');
      switch (status) {
        case 0:
          print('[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusNotDetermined');
          break;
        case 1:
          print('[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusRestricted');
          break;
        case 2:
          print('[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusDenied');
          break;
        case 3:
          print('[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusAuthorized');
          break;
      }
    });

    // Start SDK.
    Adjust.start(config);
  }

  @override
  Widget build(BuildContext context) {
    return new CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        new SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: new SliverList(
            delegate: new SliverChildListDelegate(
              <Widget>[
                const Padding(padding: const EdgeInsets.all(7.0)),

                Util.buildCupertinoButton('Is Enabled ?', () => _showIsSdkEnabled()),
                const Padding(padding: const EdgeInsets.all(7.0)),

                // Track simple event button.
                Util.buildCupertinoButton(
                    'Track Simple Event', () => Adjust.trackEvent(Util.buildSimpleEvent())),
                const Padding(padding: const EdgeInsets.all(7.0)),

                // Track revenue event button.
                Util.buildCupertinoButton(
                    'Track Revenue Event', () => Adjust.trackEvent(Util.buildRevenueEvent())),
                const Padding(padding: const EdgeInsets.all(7.0)),

                // Track callback event button.
                Util.buildCupertinoButton(
                    'Track Callback Event', () => Adjust.trackEvent(Util.buildCallbackEvent())),
                const Padding(padding: const EdgeInsets.all(7.0)),

                // Track partner event button.
                Util.buildCupertinoButton(
                    'Track Partner Event',
                    () => Adjust.trackEvent(Util.buildPartnerEvent())),
                const Padding(padding: const EdgeInsets.all(7.0)),

                // Get Google Advertising Id.
                Util.buildCupertinoButton(
                    'Get Google AdId',
                    () => Adjust.getGoogleAdId().then((googleAdid) {
                          _showDialogMessage('Get Google Advertising Id',
                              'Received Google Advertising Id: $googleAdid');
                        })),
                const Padding(padding: const EdgeInsets.all(7.0)),

                // Get Adjust identifier.
                Util.buildCupertinoButton(
                    'Get Adjust identifier',
                    () => Adjust.getAdid().then((adid) {
                          _showDialogMessage(
                              'Adjust identifier', 'Received Adjust identifier: $adid');
                        })),
                const Padding(padding: const EdgeInsets.all(7.0)),

                // Get IDFA.
                Util.buildCupertinoButton(
                    'Get IDFA',
                    () => Adjust.getIdfa().then((idfa) {
                          _showDialogMessage('IDFA', 'Received IDFA: $idfa');
                        })),
                const Padding(padding: const EdgeInsets.all(7.0)),

                // Get attribution.
                Util.buildCupertinoButton(
                    'Get attribution',
                    () => Adjust.getAttribution().then((attribution) {
                          _showDialogMessage(
                              'Attribution', 'Received attribution: ${attribution.toString()}');
                        })),
                const Padding(padding: const EdgeInsets.all(7.0)),

                // Enable / disable SDK.
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Is SDK enabled switch.
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
                          Adjust.setEnabled(value);
                          _isSdkEnabled = value;
                          print('Switch state = $_isSdkEnabled');
                        });
                      },
                    ),
                  ],
                ),
                const Padding(padding: const EdgeInsets.all(7.0)),

                // end
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showIsSdkEnabled() {
    try {
      Adjust.isEnabled().then((isEnabled) {
        _isSdkEnabled = isEnabled;
        _showDialogMessage('SDK Enabled?', 'Adjust is enabled = $isEnabled');
      });
    } on PlatformException {
      _showDialogMessage('SDK Enabled?', 'No such method found in plugin: isEnabled');
    }
  }

  void _showDialogMessage(String title, String text, [bool printToConsoleAlso = true]) {
    if (printToConsoleAlso) {
      print(text);
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            new CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context, 'OK');
              },
            )
          ],
        );
      },
    );
  }
}
