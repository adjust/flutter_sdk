import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const AdjustExampleApp());
}

class AdjustExampleApp extends StatelessWidget {
  const AdjustExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adjust Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // Event tokens
  static const String eventTokenSimple = 'g3mfiw';
  static const String eventTokenRevenue = 'a4fd35';
  static const String eventTokenCallback = '34vgg9';
  static const String eventTokenPartner = 'w788qs';
  
  // Button text for SDK toggle
  String _toggleButtonText = 'Toggle SDK';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAdjustSdk();
    _updateToggleButtonText();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializeAdjustSdk() async {
    final config = AdjustConfig('2fm9gkqubvpc', AdjustEnvironment.sandbox);
    config.logLevel = AdjustLogLevel.verbose;

    // Set up callbacks
    config.attributionCallback = (AdjustAttribution attribution) {
      print('[Adjust]: Attribution changed!');
      if (attribution.trackerToken != null) {
        print('[Adjust]: Tracker token: ${attribution.trackerToken}');
      }
      if (attribution.trackerName != null) {
        print('[Adjust]: Tracker name: ${attribution.trackerName}');
      }
      if (attribution.campaign != null) {
        print('[Adjust]: Campaign: ${attribution.campaign}');
      }
      if (attribution.network != null) {
        print('[Adjust]: Network: ${attribution.network}');
      }
      if (attribution.creative != null) {
        print('[Adjust]: Creative: ${attribution.creative}');
      }
      if (attribution.adgroup != null) {
        print('[Adjust]: Adgroup: ${attribution.adgroup}');
      }
      if (attribution.clickLabel != null) {
        print('[Adjust]: Click label: ${attribution.clickLabel}');
      }
      if (attribution.costType != null) {
        print('[Adjust]: Cost type: ${attribution.costType}');
      }
      if (attribution.costAmount != null) {
        print('[Adjust]: Cost amount: ${attribution.costAmount}');
      }
      if (attribution.costCurrency != null) {
        print('[Adjust]: Cost currency: ${attribution.costCurrency}');
      }
      if (attribution.jsonResponse != null) {
        print('[Adjust]: JSON response: ${attribution.jsonResponse}');
      }
      if (attribution.fbInstallReferrer != null) {
        print('[Adjust]: FB install referrer: ${attribution.fbInstallReferrer}');
      }
    };

    config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccess) {
      print('[Adjust]: Session tracking success!');
      if (sessionSuccess.message != null) {
        print('[Adjust]: Message: ${sessionSuccess.message}');
      }
      if (sessionSuccess.timestamp != null) {
        print('[Adjust]: Timestamp: ${sessionSuccess.timestamp}');
      }
      if (sessionSuccess.adid != null) {
        print('[Adjust]: Adid: ${sessionSuccess.adid}');
      }
      if (sessionSuccess.jsonResponse != null) {
        print('[Adjust]: JSON response: ${sessionSuccess.jsonResponse}');
      }
    };

    config.sessionFailureCallback = (AdjustSessionFailure sessionFailure) {
      print('[Adjust]: Session tracking failure!');
      if (sessionFailure.message != null) {
        print('[Adjust]: Message: ${sessionFailure.message}');
      }
      if (sessionFailure.timestamp != null) {
        print('[Adjust]: Timestamp: ${sessionFailure.timestamp}');
      }
      if (sessionFailure.adid != null) {
        print('[Adjust]: Adid: ${sessionFailure.adid}');
      }
      if (sessionFailure.willRetry != null) {
        print('[Adjust]: Will retry: ${sessionFailure.willRetry}');
      }
      if (sessionFailure.jsonResponse != null) {
        print('[Adjust]: JSON response: ${sessionFailure.jsonResponse}');
      }
    };

    config.eventSuccessCallback = (AdjustEventSuccess eventSuccess) {
      print('[Adjust]: Event tracking success!');
      if (eventSuccess.eventToken != null) {
        print('[Adjust]: Event token: ${eventSuccess.eventToken}');
      }
      if (eventSuccess.message != null) {
        print('[Adjust]: Message: ${eventSuccess.message}');
      }
      if (eventSuccess.timestamp != null) {
        print('[Adjust]: Timestamp: ${eventSuccess.timestamp}');
      }
      if (eventSuccess.adid != null) {
        print('[Adjust]: Adid: ${eventSuccess.adid}');
      }
      if (eventSuccess.callbackId != null) {
        print('[Adjust]: Callback ID: ${eventSuccess.callbackId}');
      }
      if (eventSuccess.jsonResponse != null) {
        print('[Adjust]: JSON response: ${eventSuccess.jsonResponse}');
      }
    };

    config.eventFailureCallback = (AdjustEventFailure eventFailure) {
      print('[Adjust]: Event tracking failure!');
      if (eventFailure.eventToken != null) {
        print('[Adjust]: Event token: ${eventFailure.eventToken}');
      }
      if (eventFailure.message != null) {
        print('[Adjust]: Message: ${eventFailure.message}');
      }
      if (eventFailure.timestamp != null) {
        print('[Adjust]: Timestamp: ${eventFailure.timestamp}');
      }
      if (eventFailure.adid != null) {
        print('[Adjust]: Adid: ${eventFailure.adid}');
      }
      if (eventFailure.callbackId != null) {
        print('[Adjust]: Callback ID: ${eventFailure.callbackId}');
      }
      if (eventFailure.willRetry != null) {
        print('[Adjust]: Will retry: ${eventFailure.willRetry}');
      }
      if (eventFailure.jsonResponse != null) {
        print('[Adjust]: JSON response: ${eventFailure.jsonResponse}');
      }
    };

    config.deferredDeeplinkCallback = (String? uri) {
      print('[Adjust]: Received deferred deeplink: $uri');
    };

    config.skanUpdatedCallback = (Map<String, String> skanData) {
      print('[Adjust]: Received SKAN update information!');
      if (skanData["conversion_value"] != null) {
        print('[Adjust]: Conversion value: ${skanData["conversion_value"]}');
      }
      if (skanData["coarse_value"] != null) {
        print('[Adjust]: Coarse value: ${skanData["coarse_value"]}');
      }
      if (skanData["lock_window"] != null) {
        print('[Adjust]: Lock window: ${skanData["lock_window"]}');
      }
      if (skanData["error"] != null) {
        print('[Adjust]: Error: ${skanData["error"]}');
      }
    };

    // Global parameters
    Adjust.addGlobalCallbackParameter('scp_foo_1', 'scp_bar');
    Adjust.addGlobalCallbackParameter('scp_foo_2', 'scp_value');
    Adjust.addGlobalPartnerParameter('spp_foo_1', 'spp_bar');
    Adjust.addGlobalPartnerParameter('spp_foo_2', 'spp_value');
    Adjust.removeGlobalCallbackParameter('scp_foo_1');
    Adjust.removeGlobalPartnerParameter('spp_foo_1');
    Adjust.removeGlobalCallbackParameters();
    Adjust.removeGlobalPartnerParameters();

    // Request tracking authorization
    // Adjust.requestAppTrackingAuthorization().then((status) {
    //   print('[Adjust]: Authorization status update!');
    //   switch (status.toInt()) {
    //     case 0:
    //       print('[Adjust]: ATTrackingManagerAuthorizationStatusNotDetermined');
    //       break;
    //     case 1:
    //       print('[Adjust]: ATTrackingManagerAuthorizationStatusRestricted');
    //       break;
    //     case 2:
    //       print('[Adjust]: ATTrackingManagerAuthorizationStatusDenied');
    //       break;
    //     case 3:
    //       print('[Adjust]: ATTrackingManagerAuthorizationStatusAuthorized');
    //       break;
    //   }
    // });

    // Initialize SDK
    Adjust.initSdk(config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adjust Example'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1B2951), // Adjust dark navy color
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton('Track Simple Event', _trackSimpleEvent),
            const SizedBox(height: 12),
            _buildActionButton('Track Revenue Event', _trackRevenueEvent),
            const SizedBox(height: 12),
            _buildActionButton('Track Callback Event', _trackCallbackEvent),
            const SizedBox(height: 12),
            _buildActionButton('Track Partner Event', _trackPartnerEvent),
            const SizedBox(height: 12),
            _buildActionButton('Get Google AdId', _getGoogleAdId),
            const SizedBox(height: 12),
            _buildActionButton('Get Adjust Identifier', _getAdjustIdentifier),
            const SizedBox(height: 12),
            _buildActionButton('Get IDFA', _getIdfa),
            const SizedBox(height: 12),
            _buildActionButton('Get Attribution', _getAttribution),
            const SizedBox(height: 12),
            _buildActionButton(_toggleButtonText, _toggleSdkState),
            const SizedBox(height: 12),
            _buildActionButton('Is Enabled?', _checkIfSdkEnabled),
          ],
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

  void _updateToggleButtonText() {
    try {
      Adjust.isEnabled().then((isEnabled) {
        setState(() {
          _toggleButtonText = isEnabled ? 'Disable SDK' : 'Enable SDK';
        });
      });
    } on PlatformException {
      // Keep default text if method not found
    }
  }

  void _toggleSdkState() {
    try {
      Adjust.isEnabled().then((isEnabled) {
        if (isEnabled) {
          Adjust.disable();
          print('[Adjust]: SDK disabled');
          _showDialog('SDK State', 'Adjust SDK has been disabled');
        } else {
          Adjust.enable();
          print('[Adjust]: SDK enabled');
          _showDialog('SDK State', 'Adjust SDK has been enabled');
        }
        // Update button text after toggle
        _updateToggleButtonText();
      });
    } on PlatformException {
      _showDialog('Toggle SDK', 'No such method found in plugin: isEnabled');
    }
  }

  void _checkIfSdkEnabled() {
    try {
      Adjust.isEnabled().then((isEnabled) {
        _showDialog('SDK Enabled?', 'Adjust is enabled = $isEnabled');
      });
    } on PlatformException {
      _showDialog('SDK Enabled?', 'No such method found in plugin: isEnabled');
    }
  }

  void _trackSimpleEvent() {
    final event = AdjustEvent(eventTokenSimple);
    Adjust.trackEvent(event);
  }

  void _trackRevenueEvent() {
    final event = AdjustEvent(eventTokenRevenue);
    event.setRevenue(100.0, 'EUR');
    event.transactionId = 'DummyTransactionId';
    Adjust.trackEvent(event);
  }

  void _trackCallbackEvent() {
    final event = AdjustEvent(eventTokenCallback);
    event.addCallbackParameter('key1', 'value1');
    event.addCallbackParameter('key2', 'value2');
    Adjust.trackEvent(event);
  }

  void _trackPartnerEvent() {
    final event = AdjustEvent(eventTokenPartner);
    event.addPartnerParameter('foo1', 'bar1');
    event.addPartnerParameter('foo2', 'bar2');
    Adjust.trackEvent(event);
  }

  void _getGoogleAdId() {
    Adjust.getGoogleAdId().then((googleAdId) {
      _showDialog('Get Google Advertising Id', 'Received Google Advertising Id: $googleAdId');
    });
  }

  void _getAdjustIdentifier() {
    Adjust.getAdid().then((adid) {
      _showDialog('Adjust Identifier', 'Received Adjust identifier: $adid');
    });
  }

  void _getIdfa() {
    Adjust.getIdfa().then((idfa) {
      _showDialog('IDFA', 'Received IDFA: $idfa');
    });
  }

  void _getAttribution() {
    Adjust.getAttribution().then((attribution) {
      String attributionInfo = 'Attribution data:\n';
      if (attribution.trackerToken != null) {
        attributionInfo += 'Tracker token: ${attribution.trackerToken}\n';
      }
      if (attribution.trackerName != null) {
        attributionInfo += 'Tracker name: ${attribution.trackerName}\n';
      }
      if (attribution.campaign != null) {
        attributionInfo += 'Campaign: ${attribution.campaign}\n';
      }
      if (attribution.network != null) {
        attributionInfo += 'Network: ${attribution.network}\n';
      }
      if (attribution.creative != null) {
        attributionInfo += 'Creative: ${attribution.creative}\n';
      }
      if (attribution.adgroup != null) {
        attributionInfo += 'Adgroup: ${attribution.adgroup}\n';
      }
      if (attribution.clickLabel != null) {
        attributionInfo += 'Click label: ${attribution.clickLabel}\n';
      }
      if (attribution.costType != null) {
        attributionInfo += 'Cost type: ${attribution.costType}\n';
      }
      if (attribution.costAmount != null) {
        attributionInfo += 'Cost amount: ${attribution.costAmount}\n';
      }
      if (attribution.costCurrency != null) {
        attributionInfo += 'Cost currency: ${attribution.costCurrency}\n';
      }
      if (attribution.jsonResponse != null) {
        attributionInfo += 'JSON response: ${attribution.jsonResponse}\n';
      }
      if (attribution.fbInstallReferrer != null) {
        attributionInfo += 'FB install referrer: ${attribution.fbInstallReferrer}\n';
      }
        
      _showDialog('Attribution', attributionInfo);
    });
  }

  void _showDialog(String title, String message) {
    print(message);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
