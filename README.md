## Summary

This is the Flutter SDK of Adjust™. You can read more about Adjust™ at [adjust.com].

## Table of contents

### Quick start

   * [Example apps](#qs-example-apps)
   * [Getting started](#qs-getting-started)
      * [Add the SDK to your project](#qs-add-sdk)
      * [[Android] Add Google Play Services](#qs-gps)
      * [[Android] Add permissions](#qs-permissions)
      * [[Android] Proguard settings](#qs-proguard)
      * [[Android] Install referrer](#qs-install-referrer)
         * [[Android] Google Play Referrer API](#qs-gpr-api)
         * [[Android] Google Play Store intent](#qs-gps-intent)
   * [Integrate the SDK into your app](#qs-integrate-sdk)
      * [Basic setup](#qs-basic-setup)
      * [Session tracking](#qs-session-tracking)
         * [Session tracking in Android](#qs-session-tracking-android)
      * [SDK signature](#qs-sdk-signature)
      * [Adjust logging](#qs-adjust-logging)
      * [Build your app](#qs-build-the-app)

### Deep linking

   * [Deep linking](#dl)
   * [Standard deep linking scenario](#dl-standard)
   * [Deferred deep linking scenario](#dl-deferred)
   * [Deep linking handling in Android app](#dl-app-android)
   * [Deep linking handling in iOS app](#dl-app-ios)
   * [Reattribution via deep links](#dl-reattribution)

### Event tracking

   * [Track event](#et-tracking)
   * [Track revenue](#et-revenue)
   * [Revenue deduplication](#et-revenue-deduplication)

### Custom parameters

   * [Event parameters](#cp-event-parameters)
      * [Event callback parameters](#cp-event-callback-parameters)
      * [Event partner parameters](#cp-event-partner-parameters)
      * [Event callback identifier](#cp-event-callback-id)
   * [Session parameters](#cp-session-parameters)
      * [Session callback parameters](#cp-session-callback-parameters)
      * [Session partner parameters](#cp-session-partner-parameters)
      * [Delay start](#cp-delay-start)

### Additional features

   * [Push token (uninstall tracking)](#af-push-token)
   * [Attribution callback](#af-attribution-callback)
   * [Session and event callbacks](#af-session-event-callbacks)
   * [User attribution](#af-user-attribution)
   * [Device IDs](#af-device-ids)
      * [iOS advertising identifier](#af-idfa)
      * [Google Play Services advertising identifier](#af-gps-adid)
      * [Amazon advertising identifier](#af-amazon-adid)
      * [Adjust device identifier](#af-adid)
   * [Pre-installed trackers](#af-pre-installed-trackers)
   * [Offline mode](#af-offline-mode)
   * [Disable tracking](#af-disable-tracking)
   * [Event buffering](#af-event-buffering)
   * [Background tracking](#af-background-tracking)
   * [GDPR right to be forgotten](#af-gdpr-forget-me)

### License


## Quick start

### <a id="qs-example-apps"></a>Example apps

There are example Flutter app inside the [`example` directory][example-app]. In there you can check how the Adjust SDK can be integrated.

### <a id="qs-getting-started"></a>Getting started

These are the minimal steps required to integrate the Adjust SDK into your Flutter app.

### <a id="qs-add-sdk"></a>Add the SDK to your project

You can add Adjust SDK to your Flutter app by adding following to your `pubspec.yaml` file:

```yaml
dependencies:
  adjust_sdk: ^4.17.0
```

Then navigate to your project in the terminal and run:

```
flutter packages get
```

**Note**: If you are using Visual Studio Code to develop your app, upon editing `pubspec.yaml`, it will automatically run this command, so you don't need to run it manually.

### <a id="qs-gps"></a>[Android] Add Google Play Services

Since the 1st of August of 2014, apps in the Google Play Store must use the [Google Advertising ID][google-ad-id] to uniquely identify devices. To allow the Adjust SDK to use the Google Advertising ID, you must integrate the [Google Play Services][google-play-services]. If you haven't done this yet, please add dependency to Google Play Services library by adding following dependecy to your `dependencies` block of app's `build.gradle` file for Android platform:

```gradle
implementation 'com.google.android.gms:play-services-analytics:16.0.4'
```

**Note**: The Adjust SDK is not tied to any specific version of the `play-services-analytics` part of the Google Play Services library, so feel free to always use the latest version of it (or whichever you might need).

### <a id="qs-permissions"></a>[Android] Add permissions

Please add the following permissions, which the Adjust SDK needs, if they are not already present in your `AndroidManifest.xml` file for Android platform:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

If you are **not targeting the Google Play Store**, please also add the following permission:

```xml
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
```

### <a id="qs-proguard"></a>[Android] Proguard settings

If you are using Proguard, add these lines to your Proguard file:

```
-keep public class com.adjust.sdk.** { *; }
-keep class com.google.android.gms.common.ConnectionResult {
    int SUCCESS;
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient {
    com.google.android.gms.ads.identifier.AdvertisingIdClient$Info getAdvertisingIdInfo(android.content.Context);
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {
    java.lang.String getId();
    boolean isLimitAdTrackingEnabled();
}
-keep public class com.android.installreferrer.** { *; }
```

If you are **not publishing your app in the Google Play Store**, you can leave just `com.adjust.sdk` package rules:

```
-keep public class com.adjust.sdk.** { *; }
```

### <a id="qs-install-referrer"></a>[Android] Install referrer

In order to correctly attribute an install of your app to its source, Adjust needs information about the **install referrer**. This can be obtained by using the **Google Play Referrer API** or by catching the **Google Play Store intent** with a broadcast receiver.

**Important**: The Google Play Referrer API is newly introduced by Google with the express purpose of providing a more reliable and secure way of obtaining install referrer information and to aid attribution providers in the fight against click injection. It is **strongly advised** that you support this in your application. The Google Play Store intent is a less secure way of obtaining install referrer information. It will continue to exist in parallel with the new Google Play Referrer API temporarily, but it is set to be deprecated in future.

### <a id="qs-gpr-api"></a>[Android] Google Play Referrer API

In order to support this in your app, please make sure to add following dependency to your app's `build.gradle` file for Android platform:

```
implementation 'com.android.installreferrer:installreferrer:1.0'
```

Also, make sure that you have paid attention to the [Proguard settings](#qs-proguard) chapter and that you have added all the rules mentioned in it, especially the one needed for this feature:

```
-keep public class com.android.installreferrer.** { *; }
```

### <a id="qs-gps-intent"></a>[Android] Google Play Store intent

The Google Play Store `INSTALL_REFERRER` intent should be captured with a broadcast receiver. If you are **not using your own broadcast receiver** to receive the `INSTALL_REFERRER` intent, add the following `receiver` tag inside the `application` tag in your `AndroidManifest.xml` file for Android platform.

```xml
<receiver
    android:name="com.adjust.sdk.AdjustReferrerReceiver"
    android:permission="android.permission.INSTALL_PACKAGES"
    android:exported="true" >
    <intent-filter>
        <action android:name="com.android.vending.INSTALL_REFERRER" />
    </intent-filter>
</receiver>
```

We use this broadcast receiver to retrieve the install referrer and pass it to our backend.

If you are already using a different broadcast receiver for the `INSTALL_REFERRER` intent, follow [these instructions][multiple-receivers] to add the Adjust broadcast receiver.

### <a id="qs-integrate-sdk"></a>Integrate the SDK into your app

To start with, we'll set up basic session tracking.

### <a id="qs-basic-setup"></a>Basic setup

Make sure to initialise Adjust SDK as soon as possible in your Flutter app (upon loading first widget in your app). You can initialise Adjust SDK like described below:

```dart
AdjustConfig config = new AdjustConfig('{YourAppToken}', AdjustEnvironment.sandbox);
Adjust.start(config);
```

Replace `{YourAppToken}` with your app token. You can find this in your [dashboard].

Depending on whether you are building your app for testing or for production, you must set `environment` with one of these values:

```dart
AdjustEnvironment.sandbox;
AdjustEnvironment.production;
```

**Important:** This value should be set to `AdjustEnvironment.sandbox` if and only if you or someone else is testing your app. Make sure to set the environment to `AdjustEnvironment.production` before you publish the app. Set it back to `AdjustEnvironment.sandbox` when you start developing and testing it again.

We use this environment to distinguish between real traffic and test traffic from test devices. It is imperative that you keep this value meaningful at all times!

### <a id="qs-session-tracking"></a>Session tracking

**Note**: This step is **really important** and please **make sure that you implement it properly in your app**. By implementing it, you will enable proper session tracking by the Adjust SDK in your app.

Session tracking for iOS platform is supported out of the box, but in order to perform it properly on Android platform, it requires a bit of additional work described in chapter below.

### <a id="qs-session-tracking-android"></a>Session tracking in Android

On Android platform, it is important for you to hook up into app activity lifecycle methods and make a call to `Adjust.onResume()` when ever app enters foreground and a call to `Adjust.onPause()` when ever app leaves foreground. You can do this globally or per widget (call these method upon each transition from one widget to another). For example:

```dart
class AdjustExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Adjust Flutter Example App',
      home: new MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State createState() => new MainScreenState();
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState(); // <-- Initialise SDK in here.
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
          break;
        case AppLifecycleState.resumed:
          Adjust.onResume();
          break;
        case AppLifecycleState.paused:
          Adjust.onPause();
          break;
        case AppLifecycleState.suspending:
          break;
      }
    });
  }
}
```

### <a id="qs-sdk-signature"></a>SDK signature

An account manager must activate the Adjust SDK signature. Contact Adjust support (support@adjust.com) if you are interested in using this feature.

If the SDK signature has already been enabled on your account and you have access to App Secrets in your Adjust Dashboard, please use the method below to integrate the SDK signature into your app.

An App Secret is set by calling `setAppSecret` on your config instance:

```dart
AdjustConfig adjustConfig = new AdjustConfig(yourAppToken, environment);
adjustConfig.setAppSecret(secretId, info1, info2, info3, info4);
Adjust.start(adjustConfig);
```

### <a id="qs-adjust-logging"></a>Adjust logging

You can increase or decrease the amount of logs that you see during testing by setting `logLevel` member on your config instance with one of the following parameters:

```java
adjustConfig.logLevel = AdjustLogLevel.verbose; // enable all logs
adjustConfig.logLevel = AdjustLogLevel.debug; // disable verbose logs
adjustConfig.logLevel = AdjustLogLevel.info; // disable debug logs (default)
adjustConfig.logLevel = AdjustLogLevel.warn; // disable info logs
adjustConfig.logLevel = AdjustLogLevel.error; // disable warning logs
adjustConfig.logLevel = AdjustLogLevel.suppress; // disable all logs
```

### <a id="qs-build-the-app"></a>Build your app

Build and run your Flutter app. In your Android/iOS log you can check for logs coming from Adjust SDK and in there you should see message: `Install tracked`.

## Deep linking

### <a id="dl"></a>Deep linking

If you are using an Adjust tracker URL with the option to deep link into your app, there is the possibility to get information about the deep link URL and its content. Hitting the URL can happen when the user has your app already installed (standard deep linking scenario) or if they don't have the app on their device (deferred deep linking scenario). In the standard deep linking scenario, the Android platform natively offers the possibility for you to get the information about the deep link content. The deferred deep linking scenario is something which the Android platform doesn't support out of the box, and, in this case, the Adjust SDK will offer you the mechanism you need to get the information about the deep link content.

You need to set up deep linking handling in your app **on native level** - in your generated Xcode project (for iOS) and Android Studio (for Android).

### <a id="dl-standard"></a>Standard deep linking scenario

Unfortunately, in this scenario the information about the deep link can not be delivered to you in your Dart code. Once you enable your app to handle deep linking, you will get information about the deep link on native level. For more information check our chapters below on how to enable deep linking for Android and iOS apps.

### <a id="dl-deferred"></a>Deferred deep linking scenario

In order to get information about the URL content in a deferred deep linking scenario, you should set a callback method on the config object which will receive one `string` parameter where the content of the URL will be delivered. You should set this method on the config object by assigning the `deferredDeeplinkCallback` member:

```dart
AdjustConfig adjustConfig = new AdjustConfig(yourAppToken, environment);
adjustConfig.deferredDeeplinkCallback = (String uri) {
  print('[Adjust]: Received deferred deeplink: ' + uri);
};
Adjust.start(adjustConfig);
```

In deferred deep linking scenario, there is one additional setting which can be set on the config object. Once the Adjust SDK gets the deferred deep link information, we offer you the possibility to choose whether our SDK should open this URL or not. You can choose to set this option by assigning the `launchDeferredDeeplink` member of the config instance:

```dart
AdjustConfig adjustConfig = new AdjustConfig(yourAppToken, environment);
adjustConfig.launchDeferredDeeplink = true;
adjustConfig.deferredDeeplinkCallback = (String uri) {
  print('[Adjust]: Received deferred deeplink: ' + uri);
};
Adjust.start(adjustConfig);
```

If nothing is set, **the Adjust SDK will always try to launch the URL by default**.

To enable your apps to support deep linking, you should set up schemes for each supported platform.

### <a id="dl-app-android"></a>Deep linking handling in Android app

**This should be done in native Android Studio / Eclipse project.**

To set up your Android app to handle deep linking on native level, please follow our [guide][android-deeplinking] in the official Android SDK README.

### <a id="dl-app-ios"></a>Deep linking handling in iOS app

**This should be done in native Xcode project.**

To set up your iOS app (`Runner` project) to handle deep linking on native level, please follow our [guide][ios-deeplinking] in the official iOS SDK README.

### <a id="dl-reattribution"></a>Reattribution via deep links

Adjust enables you to run re-engagement campaigns through deep links. For more information on how to do that, please check our [official docs][reattribution-with-deeplinks].

If you are using this feature, in order for your user to be properly reattributed, you need to make one additional call to the Adjust SDK in your app.

Once you have received deep link content information in your app, add a call to the `appWillOpenUrl` method. By making this call, the Adjust SDK will try to find if there is any new attribution information inside of the deep link. If there is any, it will be sent to the Adjust backend. If your user should be reattributed due to a click on the adjust tracker URL with deep link content, you will see the [attribution callback](#af-attribution-callback) in your app being triggered with new attribution info for this user.

Once everything set up, inside of your native Android activity make a call to `appWillOpenUrl` method in following way:

```java
import com.adjust.sdk.flutter.AdjustSdk;

public class MainActivity extends FlutterActivity {
    // Either call make the call in onCreate.
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        Intent intent = getIntent();
        Uri data = intent.getData();
        AdjustSdk.appWillOpenUrl(data, this);
    }

    // Or make the cakll in onNewIntent.
    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Uri data = intent.getData();
        AdjustSdk.appWillOpenUrl(data, this);
    }
}
```

Depending on the `android:launchMode` setting of your Activity in the `AndroidManifest.xml` file, information about the `deep_link` parameter content will be delivered to the appropriate place in the Activity file. For more information about the possible values of the `android:launchMode` property, check [the official Android documentation][android-launch-modes].

There are two places within your desired Activity where information about the deep link content will be delivered via the `Intent` object - either in the Activity's `onCreate` or `onNewIntent` methods. Once your app has launched and one of these methods has been triggered, you will be able to get the actual deep link passed in the `deep_link` parameter in the click URL.

Once everything set up, inside of your native iOS app delegate make a call to `appWillOpenUrl` method in following way:

```objc
#import "Adjust.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [Adjust appWillOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    if ([[userActivity activityType] isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        [Adjust appWillOpenUrl:[userActivity webpageURL]];
    }
    return YES;
}

@end
```

## Event tracking

### <a id="et-tracking"></a>Track event

You can use adjust to track any event in your app. Suppose you want to track every tap on a button. You would have to create a new event token in your [dashboard]. Let's say that event token is `abc123`. In your button's click handler method you could then add the following lines to track the click:

```dart
AdjustEvent adjustEvent = new AdjustEvent('abc123');
Adjust.trackEvent(adjustEvent);
```

### <a id="et-revenue"></a>Track revenue

If your users can generate revenue by tapping on advertisements or making in-app purchases you can track those revenues with events. Lets say a tap is worth one Euro cent. You could then track the revenue event like this:

```dart
AdjustEvent adjustEvent = new AdjustEvent('abc123');
adjustEvent.setRevenue(6, 'EUR');
Adjust.trackEvent(adjustEvent);
```

This can be combined with callback parameters of course.

When you set a currency token, Adjust will automatically convert the incoming revenues into a reporting revenue of your choice. Read more about [currency conversion here][currency-conversion].

You can read more about revenue and event tracking in the [event tracking guide][event-tracking].

### <a id="et-revenue-deduplication"></a>Revenue deduplication

You can also add an optional transaction ID to avoid tracking duplicated revenues. The last ten transaction IDs are remembered, and revenue events with duplicated transaction IDs are skipped. This is especially useful for In-App Purchase tracking. You can see an example below.

If you want to track in-app purchases, please make sure to call the `trackEvent` only if the transaction is finished and item is purchased. That way you can avoid tracking revenue that is not actually being generated.

```dart
AdjustEvent adjustEvent = new AdjustEvent('abc123');
adjustEvent.transactionId = '{TransactionId}';
Adjust.trackEvent(adjustEvent);
```

## Custom parameters

### <a id="cp"></a>Custom parameters

In addition to the data points that Adjust SDK collects by default, you can use the Adjust SDK to track and add to the event/session as many custom values as you need (user IDs, product IDs, etc.). Custom parameters are only available as raw data (i.e., they won't appear in the Adjust dashboard).

You should use **callback parameters** for the values that you collect for your own internal use, and **partner parameters** for those that you wish to share with external partners. If a value (e.g. product ID) is tracked both for internal use and to forward it to external partners, the best practice would be to track it both as callback and partner parameters.


### <a id="cp-event-parameters"></a>Event parameters

### <a id="cp-event-callback-parameters"></a>Event callback parameters

You can register a callback URL for your events in your [dashboard]. We will send a GET request to that URL whenever the event is tracked. You can add callback parameters to that event by calling `addCallbackParameter` to the event instance before tracking it. We will then append these parameters to your callback URL.

For example, suppose you have registered the URL `http://www.adjust.com/callback` then track an event like this:

```dart
AdjustEvent adjustEvent = new AdjustEvent('abc123');
adjustEvent.addCallbackParameter('key', 'value');
adjustEvent.addCallbackParameter('foo', 'bar');
Adjust.trackEvent(adjustEvent);
```

In that case we would track the event and send a request to:

```
http://www.adjust.com/callback?key=value&foo=bar
```

It should be mentioned that we support a variety of placeholders like `{gps_adid}` that can be used as parameter values. In the resulting callback this placeholder would be replaced with the Google Play Services ID of the current device. Also note that we don't store any of your custom parameters, but only append them to your callbacks. If you haven't registered a callback for an event, these parameters won't even be read.

You can read more about using URL callbacks, including a full list of available values, in our [callbacks guide][callbacks-guide].

### <a id="cp-event-partner-parameters"></a>Event partner parameters

You can also add parameters to be transmitted to network partners, which have been activated in your Adjust dashboard.

This works similarly to the callback parameters mentioned above, but can be added by calling the `addPartnerParameter` method on your event instance.

```dart
AdjustEvent adjustEvent = new AdjustEvent('abc123');
adjustEvent.addPartnerParameter('key', 'value');
adjustEvent.addPartnerParameter('foo', 'bar');
Adjust.trackEvent(adjustEvent);
```

You can read more about special partners and these integrations in our [guide to special partners][special-partners].

### <a id="cp-event-callback-id"></a>Event callback identifier

You can also add custom string identifier to each event you want to track. This identifier will later be reported in event success and/or event failure callbacks to enable you to keep track on which event was successfully tracked or not. You can set this identifier by assigning the `callbackId` member of your event instance:

```dart
AdjustEvent adjustEvent = new AdjustEvent('abc123');
adjustEvent.callbackId = '{CallbackId}';
Adjust.trackEvent(adjustEvent);
```

### <a id="cp-session-parameters"></a>Session parameters

Some parameters are saved to be sent in every **event** and **session** of the Adjust SDK. Once you have added any of these parameters, you don't need to add them every time, since they will be saved locally. If you add the same parameter twice, there will be no effect.

These session parameters can be called before the Adjust SDK is launched to make sure they are sent even on install. If you need to send them with an install, but can only obtain the needed values after launch, it's possible to [delay](#delay-start) the first launch of the Adjust SDK to allow this behaviour.

### <a id="cp-session-callback-parameters"></a>Session callback parameters

The same callback parameters that are registered for [events](#event-callback-parameters) can be also saved to be sent in every  event or session of the Adjust SDK.

The session callback parameters have a similar interface to the event callback parameters. Instead of adding the key and it's value to an event, it's added through a call to `Adjust.addSessionCallbackParameter(String key, String value)`:

```dart
Adjust.addSessionCallbackParameter('foo', 'bar');
```

The session callback parameters will be merged with the callback parameters added to an event. The callback parameters added to an event have precedence over the session callback parameters. Meaning that, when adding a callback parameter to an event with the same key to one added from the session, the value that prevails is the callback parameter added to the event.

It's possible to remove a specific session callback parameter by passing the desiring key to the method `Adjust.removeSessionCallbackParameter(String key)`.

```dart
Adjust.removeSessionCallbackParameter('foo');
```

If you wish to remove all keys and their corresponding values from the session callback parameters, you can reset it with the method `Adjust.resetSessionCallbackParameters()`.

```dart
Adjust.resetSessionCallbackParameters();
```

### <a id="cp-session-partner-parameters"></a>Session partner parameters

In the same way that there are [session callback parameters](#session-callback-parameters) sent in every event or session of the Adjust SDK, there is also session partner parameters.

These will be transmitted to network partners, for the integrations that have been activated in your Adjust [dashboard].

The session partner parameters have a similar interface to the event partner parameters. Instead of adding the key and it's value to an event, it's added through a call to `Adjust.addSessionPartnerParameter(String key, String value)`:

```dart
Adjust.addSessionPartnerParameter('foo', 'bar');
```

The session partner parameters will be merged with the partner parameters added to an event. The partner parameters added to an event have precedence over the session partner parameters. Meaning that, when adding a partner parameter to an event with the same key to one added from the session, the value that prevails is the partner parameter added to the event.

It's possible to remove a specific session partner parameter by passing the desiring key to the method `Adjust.removeSessionPartnerParameter(String key)`.

```dart
Adjust.removeSessionPartnerParameter('foo');
```

If you wish to remove all keys and their corresponding values from the session partner parameters, you can reset it with the method `Adjust.resetSessionPartnerParameters()`.

```dart
Adjust.resetSessionPartnerParameters();
```

### <a id="cp-delay-start"></a>Delay start

Delaying the start of the Adjust SDK allows your app some time to obtain session parameters, such as unique identifiers, to be sent on install.

Set the initial delay time in seconds with the `delayStart` member of the config instance:

```dart
adjustConfig.delayStart = 5.5;
```

In this case, this will make the Adjust SDK not send the initial install session and any event created for 5.5 seconds. After this time is expired or if you call `Adjust.sendFirstPackages()` in the meanwhile, every session parameter will be added to the delayed install session and events and the Adjust SDK will resume as usual.

**The maximum delay start time of the adjust SDK is 10 seconds**.


## Additional features

### <a id="af"></a> Additional features

Once you have integrated the Adjust SDK into your project, you can take advantage of the following features.

### <a id="af-push-token"></a>Push token (uninstall tracking)

Push tokens are used for Audience Builder and client callbacks, and they are required for uninstall and reinstall tracking.

To send us the push notification token, add the following call to Adjust once you have obtained your token or when ever it's value is changed:

```dart
Adjust.setPushToken('{PushNotificationsToken}');
```

### <a id="af-attribution-callback"></a>Attribution callback

You can register a callback to be notified of tracker attribution changes. Due to the different sources considered for attribution, this information can not be provided synchronously.

Please make sure to consider our [applicable attribution data policies][attribution-data].

With the config instance, before starting the SDK, add the attribution callback:

```dart
AdjustConfig adjustConfig = new AdjustConfig(yourAppToken, environment);
config.attributionCallback = (AdjustAttribution attributionChangedData) {
  print('[Adjust]: Attribution changed!');

  if (attributionChangedData.trackerToken != null) {
    print('[Adjust]: Tracker token: ' + attributionChangedData.trackerToken);
  }
  if (attributionChangedData.trackerName != null) {
    print('[Adjust]: Tracker name: ' + attributionChangedData.trackerName);
  }
  if (attributionChangedData.campaign != null) {
    print('[Adjust]: Campaign: ' + attributionChangedData.campaign);
  }
  if (attributionChangedData.network != null) {
    print('[Adjust]: Network: ' + attributionChangedData.network);
  }
  if (attributionChangedData.creative != null) {
    print('[Adjust]: Creative: ' + attributionChangedData.creative);
  }
  if (attributionChangedData.adgroup != null) {
    print('[Adjust]: Adgroup: ' + attributionChangedData.adgroup);
  }
  if (attributionChangedData.clickLabel != null) {
    print('[Adjust]: Click label: ' + attributionChangedData.clickLabel);
  }
  if (attributionChangedData.adid != null) {
    print('[Adjust]: Adid: ' + attributionChangedData.adid);
  }
};
Adjust.start(adjustConfig);
```

The callback function will be called after the SDK receives the final attribution data. Within the callback function you have access to the `attribution` parameter. Here is a quick summary of its properties:

- `trackerToken` the tracker token string of the current attribution.
- `trackerName` the tracker name string of the current attribution.
- `network` the network grouping level string of the current attribution.
- `campaign` the campaign grouping level string of the current attribution.
- `adgroup` the ad group grouping level string of the current attribution.
- `creative` the creative grouping level string of the current attribution.
- `clickLabel` the click label string of the current attribution.
- `adid` the Adjust device identifier string.

### <a id="af-session-event-callbacks"></a>Session and event callbacks

You can register a callback to be notified when events or sessions are tracked. There are four callbacks: one for tracking successful events, one for tracking failed events, one for tracking successful sessions and one for tracking failed sessions. You can add any number of callbacks after creating the config object:

```dart
AdjustConfig adjustConfig = new AdjustConfig(yourAppToken, environment);

// Set session success tracking delegate.
config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
  print('[Adjust]: Session tracking success!');

  if (sessionSuccessData.message != null) {
    print('[Adjust]: Message: ' + sessionSuccessData.message);
  }
  if (sessionSuccessData.timestamp != null) {
    print('[Adjust]: Timestamp: ' + sessionSuccessData.timestamp);
  }
  if (sessionSuccessData.adid != null) {
    print('[Adjust]: Adid: ' + sessionSuccessData.adid);
  }
  if (sessionSuccessData.jsonResponse != null) {
    print('[Adjust]: JSON response: ' + sessionSuccessData.jsonResponse);
  }
};

// Set session failure tracking delegate.
config.sessionFailureCallback = (AdjustSessionFailure sessionFailureData) {
  print('[Adjust]: Session tracking failure!');

  if (sessionFailureData.message != null) {
    print('[Adjust]: Message: ' + sessionFailureData.message);
  }
  if (sessionFailureData.timestamp != null) {
    print('[Adjust]: Timestamp: ' + sessionFailureData.timestamp);
  }
  if (sessionFailureData.adid != null) {
    print('[Adjust]: Adid: ' + sessionFailureData.adid);
  }
  if (sessionFailureData.willRetry != null) {
    print('[Adjust]: Will retry: ' + sessionFailureData.willRetry.toString());
  }
  if (sessionFailureData.jsonResponse != null) {
    print('[Adjust]: JSON response: ' + sessionFailureData.jsonResponse);
  }
};

// Set event success tracking delegate.
config.eventSuccessCallback = (AdjustEventSuccess eventSuccessData) {
  print('[Adjust]: Event tracking success!');

  if (eventSuccessData.eventToken != null) {
    print('[Adjust]: Event token: ' + eventSuccessData.eventToken);
  }
  if (eventSuccessData.message != null) {
    print('[Adjust]: Message: ' + eventSuccessData.message);
  }
  if (eventSuccessData.timestamp != null) {
    print('[Adjust]: Timestamp: ' + eventSuccessData.timestamp);
  }
  if (eventSuccessData.adid != null) {
    print('[Adjust]: Adid: ' + eventSuccessData.adid);
  }
  if (eventSuccessData.callbackId != null) {
    print('[Adjust]: Callback ID: ' + eventSuccessData.callbackId);
  }
  if (eventSuccessData.jsonResponse != null) {
    print('[Adjust]: JSON response: ' + eventSuccessData.jsonResponse);
  }
};

// Set event failure tracking delegate.
config.eventFailureCallback = (AdjustEventFailure eventFailureData) {
  print('[Adjust]: Event tracking failure!');

  if (eventFailureData.eventToken != null) {
    print('[Adjust]: Event token: ' + eventFailureData.eventToken);
  }
  if (eventFailureData.message != null) {
    print('[Adjust]: Message: ' + eventFailureData.message);
  }
  if (eventFailureData.timestamp != null) {
    print('[Adjust]: Timestamp: ' + eventFailureData.timestamp);
  }
  if (eventFailureData.adid != null) {
    print('[Adjust]: Adid: ' + eventFailureData.adid);
  }
  if (eventFailureData.callbackId != null) {
    print('[Adjust]: Callback ID: ' + eventFailureData.callbackId);
  }
  if (eventFailureData.willRetry != null) {
    print('[Adjust]: Will retry: ' + eventFailureData.willRetry.toString());
  }
  if (eventFailureData.jsonResponse != null) {
    print('[Adjust]: JSON response: ' + eventFailureData.jsonResponse);
  }
};

Adjust.start(adjustConfig);
```

The callback function will be called after the SDK tries to send a package to the server. Within the callback function you have access to a response data object specifically for the callback. Here is a quick summary of the success session response data object fields:

- `message` message string from the server or the error logged by the SDK.
- `timestamp` timestamp string from the server.
- `adid` a unique string device identifier provided by Adjust.
- `jsonResponse` the JSON object with the reponse from the server.

Both event response data objects contain:

- `eventToken` the event token string, if the package tracked was an event.
- `callbackId` the custom defined [callback ID](#cp-event-callback-id) string set on event object.

And both event and session failed objects also contain:

- `willRetry` boolean which indicates whether there will be an attempt to resend the package at a later time.

### <a id="af-user-attribution"></a>User attribution

Like described in [attribution callback section](#af-attribution-callback), this callback get triggered providing you info about new attribution when ever it changes. In case you want to access info about your user's current attribution whenever you need it, you can make a call to following method of the `Adjust` instance:

```dart
AdjustAttribution attribution = Adjust.getAttribution();
```

**Note**: Information about current attribution is available after app installation has been tracked by the Adjust backend and attribution callback has been initially triggered. From that moment on, Adjust SDK has information about your user's attribution and you can access it with this method. So, **it is not possible** to access user's attribution value before the SDK has been initialized and attribution callback has been initially triggered.

### <a id="af-device-ids"></a>Device IDs

The Adjust SDK offers you possibility to obtain some of the device identifiers.

### <a id="af-idfa"></a>iOS Advertising Identifier

To obtain the IDFA, call the `getIdfa` method of the `Adjust` instance:

```dart
Adjust.getIdfa().then((idfa) {
  // Use idfa string value.
});
```

### <a id="af-gps-adid"></a>Google Play Services advertising identifier

Certain services (such as Google Analytics) require you to coordinate Device and Client IDs in order to prevent duplicate reporting.

To obtain the device Google Advertising identifier, it's necessary to pass a callback function to `Adjust.getGoogleAdId` that will receive the Google Advertising ID in it's argument, like this:

```dart
Adjust.getGoogleAdId().then((googleAdId) {
  // Use googleAdId string value.
});
```

### <a id="af-amazon-adid"></a>Amazon advertising identifier

To obtain the Amazon advertising identifier, call the `getAmazonAdId` method of the `Adjust` instance:

```dart
Adjust.getAmazonAdId().then((amazonAdId) {
  // Use amazonAdId string value.
});
```

### <a id="af-adid"></a>Adjust device identifier

For each device with your app installed on it, Adjust backend generates unique **Adjust device identifier** (**adid**). In order to obtain this identifier, you can make a call the `getAdid` method of the `Adjust` instance:

```dart
Adjust.getAdid().then((adid) {
  // Use adid string value.
});
```

**Note**: Information about **adid** is available after app installation has been tracked by the Adjust backend. From that moment on, Adjust SDK has information about your device **adid** and you can access it with this method. So, **it is not possible** to access **adid** value before the SDK has been initialised and installation of your app was tracked successfully.

### <a id="af-pre-installed-trackers"></a>Pre-installed trackers

If you want to use the Adjust SDK to recognize users whose devices came with your app pre-installed, follow these steps.

- Create a new tracker in your [dashboard].
- Set the default tracker of your config object:

  ```dart
  adjustConfig.defaultTracker = '{TrackerToken}';
  ```
  Replace `{TrackerToken}` with the tracker token you created in step 1. Please note that the Dashboard displays a tracker URL (including `http://app.adjust.com/`). In your source code, you should specify only the six-character token and not the entire URL.

- Build and run your app. You should see a line like the following in your LogCat:

  ```
  Default tracker: 'abc123'
  ```

### <a id="af-offline-mode"></a>Offline mode

You can put the Adjust SDK in offline mode to suspend transmission to our servers, while retaining tracked data to be sent later. While in offline mode, all information is saved in a file, so be careful not to trigger too many events while in offline mode.

You can activate offline mode by calling `setOfflineMode` with the parameter `true`.

```dart
Adjust.setOfflineMode(true);
```

Conversely, you can deactivate offline mode by calling `setOfflineMode` with `false`. When the Adjust SDK is put back in online mode, all saved information is sent to our servers with the correct time information.

Unlike disabling tracking, this setting is **not remembered** between sessions. This means that the SDK is in online mode whenever it is started, even if the app was terminated in offline mode.

### <a id="af-disable-tracking"></a>Disable tracking

You can disable the Adjust SDK from tracking any activities of the current device by calling `setEnabled` with parameter `false`. **This setting is remembered between sessions**.

```dart
Adjust.setEnabled(false);
```

You can check if the Adjust SDK is currently enabled by calling the function `isEnabled`. It is always possible to activatе the Adjust SDK by invoking `setEnabled` with the enabled parameter as `true`.

### <a id="af-event-buffering"></a>Event buffering

If your app makes heavy use of event tracking, you might want to delay some HTTP requests in order to send them in one batch every minute. You can enable event buffering with your config instance:

```dart
adjustConfig.eventBufferingEnabled = true;
```

### <a id="af-background-tracking"></a>Background tracking

The default behaviour of the Adjust SDK is to pause sending HTTP requests while the app is in the background. You can change this in your config instance:

```dart
adjustConfig.sendInBackground = true;
```

### <a id="af-gdpr-forget-me"></a>GDPR right to be forgotten

In accordance with article 17 of the EU's General Data Protection Regulation (GDPR), you can notify Adjust when a user has exercised their right to be forgotten. Calling the following method will instruct the Adjust SDK to communicate the user's choice to be forgotten to the Adjust backend:

```dart
Adjust.gdprForgetMe();
```

Upon receiving this information, Adjust will erase the user's data and the Adjust SDK will stop tracking the user. No requests from this device will be sent to Adjust in the future.


[dashboard]:  http://adjust.com
[adjust.com]: http://adjust.com

[example-app]: example

[multiple-receivers]:             https://github.com/adjust/android_sdk/blob/master/doc/english/referrer.md
[google-ad-id]:                   https://support.google.com/googleplay/android-developer/answer/6048248?hl=en
[event-tracking]:                 https://docs.adjust.com/en/event-tracking
[callbacks-guide]:                https://docs.adjust.com/en/callbacks
[ios-deeplinking]:                https://github.com/adjust/ios_sdk/#deep-linking
[new-referrer-api]:               https://developer.android.com/google/play/installreferrer/library.html
[special-partners]:               https://docs.adjust.com/en/special-partners
[attribution-data]:               https://github.com/adjust/sdks/blob/master/doc/attribution-data.md
[currency-conversion]:            https://docs.adjust.com/en/event-tracking/#tracking-purchases-in-different-currencies
[android-deeplinking]:            https://github.com/adjust/android_sdk#deep-linking
[android-launch-modes]:           https://developer.android.com/guide/topics/manifest/activity-element.html
[google-play-services]:           http://developer.android.com/google/play-services/setup.html
[reattribution-with-deeplinks]:   https://docs.adjust.com/en/deeplinking/#manually-appending-attribution-data-to-a-deep-link

## <a id="license"></a>License

The Adjust SDK is licensed under the MIT License.

Copyright (c) 2012-2018 Adjust GmbH, http://www.adjust.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
