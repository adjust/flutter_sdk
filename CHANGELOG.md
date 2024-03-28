### Version 4.38.0 (28th March 2024)
#### Added
- Added iOS Privacy Manifest for the Adjust SDK.
- Added new domains and corresponding payload restrictions for the Adjust SDK to direct the iOS traffic to:
    - https://consent.adjust.com - for consented users
    - https://analytics.adjust.com - for non-consented users

#### Native SDKs
- [iOS@v4.38.0][ios_sdk_v4.38.0]
- [Android@v4.38.3][android_sdk_v4.38.3]

---

### Version 4.37.1 (21st February 2024)
#### Added
- Added support for `TradPlus` ad revenue tracking.

#### Fixed
- Fixed return type mismatch between native Android and Dart implementation of iOS specific methods (https://github.com/adjust/flutter_sdk/issues/122).

#### Native SDKs
- [iOS@v4.37.1][ios_sdk_v4.37.1]
- [Android@v4.38.1][android_sdk_v4.38.1]

---

### Version 4.37.0 (23rd January 2024)
#### Added
- Added ability to process shortened deep links and provide the unshortened link back as a response. You can achieve this by invoking `processDeeplink` method of the `Adjust` instance.

#### Native SDKs
- [iOS@v4.37.0][ios_sdk_v4.37.0]
- [Android@v4.38.0][android_sdk_v4.38.0]

---

### Version 4.36.0 (27th November 2023)
#### Added
- Added getter for obtaining IDFV value of the iOS device.
- Added support for Meta install referrer.
- Added support for Google Play Games on PC.
- Added support for `TopOn` and `AD(X)` ad revenue tracking.
- Added a new type of URL strategy called `AdjustConfig.UrlStrategyCnOnly`. This URL strategy represents `AdjustConfig.UrlStrategyCn` strategy, but without fallback domains.
- Added `readDeviceInfoOnceEnabled` member to `AdjustConfig` to indicate if Android device info should be read only once.

#### Native SDKs
- [iOS@v4.36.0][ios_sdk_v4.36.0]
- [Android@v4.37.0][android_sdk_v4.37.0]

---

### Version 4.35.2 (9th October 2023)
#### Added
- Added sending of `event_callback_id` parameter (if set) with the event payload.

#### Native SDKs
- [iOS@v4.35.2][ios_sdk_v4.35.2]
- [Android@v4.35.1][android_sdk_v4.35.1]

---

### Version 4.35.1 (2nd October 2023)
#### Fixed
- Fixed issue with signing iOS requests post ATT delay timer expiry.

#### Native SDKs
- [iOS@v4.35.1][ios_sdk_v4.35.1]
- [Android@v4.35.0][android_sdk_v4.35.0]

---

### Version 4.35.0 (27th September 2023)
#### Added
- Added support for SigV3 library. Update authorization header building logic to use `adj_signing_id`.
- Added ability to indicate if only final Android attribution is needed in attribution callback (by default attribution callback return intermediate attribution as well before final attribution if not enabled with this setter method) by setting the `androidFinalAttributionEnabled` member of the `AdjustConfig` instance.

#### Native SDKs
- [iOS@v4.35.0][ios_sdk_v4.35.0]
- [Android@v4.35.0][android_sdk_v4.35.0]

---

### Version 4.34.0 (6th September 2023)
#### Added
- Added support for Android apps using Gradle 8.0 or later.
- Added ability to delay SDK start on iOS platform in order to wait for an answer to the ATT dialog. You can set the number of seconds to wait (capped internally to 120) by setting the `attConsentWaitingInterval` member of the `AdjustConfig` instance.
- Added support for purchase verification. In case you are using this feature, you can now use it by calling `verifyAppStorePurchase` (for iOS) and `verifyPlayStorePurchase` (for Android) methods of the `Adjust` instance.

#### Native SDKs
- [iOS@v4.34.2][ios_sdk_v4.34.2]
- [Android@v4.34.0][android_sdk_v4.34.0]

---

### Version 4.33.1 (16th February 2023)
#### Fixed
- Skipped invocation of SKAN 4.0 style callback in case SKAN 4.0 API was not invoked (https://github.com/adjust/flutter_sdk/issues/104).

#### Native SDKs
- [iOS@v4.33.4][ios_sdk_v4.33.4]
- [Android@v4.33.3][android_sdk_v4.33.3]

---

### Version 4.33.0 (9th December 2022)
#### Added
- Added support for SKAN 4.0.
- Added support for setting a new China URL Strategy. You can choose this setting by setting `urlStrategy` member of `AdjustConfig` instance to `AdjustConfig.UrlStrategyCn` value.

#### Native SDKs
- [iOS@v4.33.2][ios_sdk_v4.33.2]
- [Android@v4.33.2][android_sdk_v4.33.2]

---

### Version 4.32.0 (7th October 2022)
#### Added
- Added partner sharing settings to the third party sharing feature.
- Added `getLastDeeplink` getter to `Adjust` API to be able to get last tracked deep link by the SDK for iOS platform.

#### Changed
- Switched to adding permission `com.google.android.gms.permission.AD_ID` in the Android app's mainfest by default.

#### Native SDKs
- [iOS@v4.32.1][ios_sdk_v4.32.1]
- [Android@v4.32.0][android_sdk_v4.32.0]

---

### Version 4.31.0 (3rd August 2022)
#### Added
- Added support for `LinkMe` feature.
- Added support to get Facebook install referrer information in attribution callback.

#### Native SDKs
- [iOS@v4.31.0][ios_sdk_v4.31.0]
- [Android@v4.31.0][android_sdk_v4.31.0]

---

### Version 4.30.0 (9th June 2022)
#### Added
- Added ability to mark your app as COPPA compliant. You can enable this setting by setting `coppaCompliantEnabled` member of `AdjustConfig` instance to `true`.
- Added ability to mark your Android app as app for the kids in accordance to Google Play Families policies. You can enable this setting by setting `playStoreKidsAppEnabled` member of `AdjustConfig` instance to `true`.
- Added `checkForNewAttStatus` method to `Adjust` API to allow iOS apps to instruct to SDK to check if `att_status` might have changed in the meantime.
- Added support for Generic ad revenue tracking.

#### Changed
- Reverted `compileSdkVersion` from `32` to `31` (https://github.com/adjust/flutter_sdk/pull/77).
- Changed responses which is being returned when iOS specific API is being called on Android platform (https://github.com/adjust/flutter_sdk/issues/79 and https://github.com/adjust/flutter_sdk/issues/80).

#### Native SDKs
- [iOS@v4.30.0][ios_sdk_v4.30.0]
- [Android@v4.30.1][android_sdk_v4.30.1]

---

### Version 4.29.2 (18th February 2022)
#### Added
- Added support for `Unity` ad revenue tracking.
- Added support for `Helium Chartboost` ad revenue tracking.

#### Changed
- Removed deprecated v1 way of plugin registration (https://github.com/adjust/flutter_sdk/issues/64).
- Migrated from `jcenter` to `mavenCentral` repository (https://github.com/adjust/flutter_sdk/pull/72).

#### Native SDKs
- [iOS@v4.29.7][ios_sdk_v4.29.7]
- [Android@v4.29.1][android_sdk_v4.29.1]

---

### Version 4.29.1 (23rd September 2021)
#### Added
- Added support for `Admost` ad revenue source.

#### Fixed
- Fixed compile time errors with Xcode 13.

#### Native SDKs
- [iOS@v4.29.6][ios_sdk_v4.29.6]
- [Android@v4.28.5][android_sdk_v4.28.5]

---

### Version 4.29.0 (11th June 2021)
#### Added
- Added support for null safety (thanks to @blaueeiner).
- [beta] Added data residency feature. You can choose this setting by setting `urlStrategy` member of `AdjustConfig` instance to `AdjustConfig.DataResidencyEU` (for EU data residency region), `AdjustConfig.DataResidencyTR` (for TR data residency region) or `AdjustConfig.DataResidencyUS` value (for US data residency region).
- Added `trackAdRevenueNew` method to `Adjust` interface to allow tracking of ad revenue by passing `AdjustAdRevenue` object as parameter.
- Added support for `AppLovin MAX` ad revenue tracking.
- Added `conversionValueUpdatedCallback` member to `AdjustConfig` which can be used to set a callback which will get information when Adjust SDK updates conversion value for the user.
- Added preinstall tracking with usage of system installer receiver on Android platform.

#### Fixed
- Fixed attribution value comparison logic which might cause same attribution value to be delivered into attribution callback on iOS platform.

#### Native SDKs
- [iOS@v4.29.2][ios_sdk_v4.29.2]
- [Android@v4.28.1][android_sdk_v4.28.1]

---

### Version 4.28.0 (2nd April 2021)
#### Changed
- Removed native iOS legacy code.

#### Native SDKs
- [iOS@v4.28.0][ios_sdk_v4.28.0]
- [Android@v4.27.0][android_sdk_v4.27.0]

---

### Version 4.26.0 (23rd February 2021)
#### Added
- Added possibility to get cost data information in attribution callback.
- Added `needsCost` member to `AdjustConfig` to indicate if cost data is needed in attribution callback (by default cost data will not be part of attribution callback if not enabled with this setter method).
- Added `preinstallTrackingEnabled` member to `AdjustConfig` to allow enabling of preinstall tracking (this feature is OFF by default).
- Added support for Apple Search Ads attribution with usage of `AdServices.framework`.
- Added `allowAdServicesInfoReading` member to `AdjustConfig` to allow option for users to prevent SDK from performing any tasks related to Apple Search Ads attribution with usage of `AdServices.framework`.
- Added wrapper method `updateConversionValue` method to `Adjust` to allow updating SKAdNetwork conversion value via SDK API.
- Added `getAppTrackingAuthorizationStatus` getter to `Adjust` instance to be able to get current iOS app tracking status.
- Added improved measurement consent management and third party sharing mechanism.
- Added public constants to be used as sources for ad revenue tracking with `trackAdRevenue` method.

#### Changed
- Updated Gradle version to 6.5 (thanks to @MrtnvM).

#### Fixed
- Fixed occasional NPEs in Android when firing callback methods.

#### Native SDKs
- [iOS@v4.26.1][ios_sdk_v4.26.1]
- [Android@v4.26.2][android_sdk_v4.26.2]

---

### Version 4.23.3 (18th December 2020)
#### Added
- Added URL strategy constants to `AdjustConfig` for more straight forward feature usage.

#### Native SDKs
- [iOS@v4.23.2][ios_sdk_v4.23.2]
- [Android@v4.24.1][android_sdk_v4.24.1]

---

### Version 4.23.2 (11th November 2020)
#### Added
- Added [Flutter 1.2 or later](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects) support for Android projects.

#### Native SDKs
- [iOS@v4.23.2][ios_sdk_v4.23.2]
- [Android@v4.24.1][android_sdk_v4.24.1]

---

### Version 4.23.1 (31st August 2020)
#### Fixed
- Removed `iosPrefix` from `pubspec.yaml`.
- Removed `ADJ` prefix from Flutter iOS class names.

#### Native SDKs
- [iOS@v4.23.0][ios_sdk_v4.23.0]
- [Android@v4.24.0][android_sdk_v4.24.0]

---

### Version 4.23.0 (28th August 2020)
#### Added
- Added communication with SKAdNetwork framework by default on iOS 14.
- Added method `deactivateSKAdNetworkHandling` method to `AdjustConfig` to switch off default communication with SKAdNetwork framework in iOS 14.
- Added wrapper method `requestTrackingAuthorizationWithCompletionHandler` to `Adjust` to allow asking for user's consent to be tracked in iOS 14 and immediate propagation of user's choice to backend.
- Added handling of new iAd framework error codes introduced in iOS 14.
- Added sending of value of user's consent to be tracked with each package.
- Added `urlStrategy` member to `AdjustConfig` class to allow selection of URL strategy for specific market.

#### Native SDKs
- [iOS@v4.23.0][ios_sdk_v4.23.0]
- [Android@v4.24.0][android_sdk_v4.24.0]

---

### Version 4.22.1 (3rd August 2020)
#### Changed
- Changed referencing of native Android dependency from `implementation` to `api`.

#### Native SDKs
- [iOS@v4.22.1][ios_sdk_v4.22.1]
- [Android@v4.22.0][android_sdk_v4.22.0]

---

### Version 4.22.0 (10th June 2020)
#### Added
- Added subscription tracking feature.
- Added support for Huawei App Gallery install referrer.

#### Changed
- Updated communication flow with `iAd.framework`.

#### Native SDKs
- [iOS@v4.22.1][ios_sdk_v4.22.1]
- [Android@v4.22.0][android_sdk_v4.22.0]

---

### Version 4.21.0 (25th March 2021)
#### Added
- Added `disableThirdPartySharing` method to `Adjust` interface to allow disabling of data sharing with third parties outside of Adjust ecosystem.
- Added support for signature library as a plugin.
- Added more aggressive sending retry logic for install session package.
- Added additional parameters to `ad_revenue` package payload.
- Added external device ID support.

#### Native SDKs
- [iOS@v4.21.0][ios_sdk_v4.21.0]
- [Android@4.21.0][android_sdk_v4.21.0]

---

### Version 4.18.1 (9th October 2019)
#### Fixed
- Fixed lack of `getAdid` method implementation in native iOS bridge (thanks to @HenriBeck).

#### Native SDKs
- [iOS@v4.18.3][ios_sdk_v4.18.3]
- [Android@v4.18.3][android_sdk_v4.18.3]

---

### Version 4.18.0 (4th July 2019)
#### Added
- Added `trackAdRevenue` method to `Adjust` interface to allow tracking of ad revenue. With this release added support for `MoPub` ad revenue tracking.
- Added reading of Facebook anonymous ID if available on iOS platform.

#### Native SDKs
- [iOS@v4.18.0][ios_sdk_v4.18.0]
- [Android@v4.18.0][android_sdk_v4.18.0]

---

### Version 4.17.1 (5th June 2019)
#### Fixed
- Fixed issue when trying to register Android plugin more than once (https://github.com/adjust/flutter_sdk/issues/7).

#### Native SDKs
- [iOS@v4.17.3][ios_sdk_v4.17.3]
- [Android@v4.17.0][android_sdk_v4.17.0]

---

### Version 4.17.0 (4th December 2018)
#### Added
- Official Flutter SDK release.

#### Native SDKs
- [iOS@v4.17.0][ios_sdk_v4.17.0]
- [Android@v4.17.0][android_sdk_v4.17.0]

---

### Version 0.0.4 (4th December 2018)
#### Changed
- Changed SDK API to be more Dart friendly.

#### Native SDKs
- [iOS@v4.17.0][ios_sdk_v4.17.0]
- [Android@v4.17.0][android_sdk_v4.17.0]

---

### Version 0.0.3 (4th December 2018)
#### Changed
- Changed SDK dependency in example app from local path to Flutter plugin repository.

#### Native SDKs
- [iOS@v4.17.0][ios_sdk_v4.17.0]
- [Android@v4.17.0][android_sdk_v4.17.0]

---

### Version 0.0.2 (4th December 2018)
#### Added
- Added example app to repo.
- Added handling of process name for Android platform.

#### Native SDKs
- [iOS@v4.17.0][ios_sdk_v4.17.0]
- [Android@v4.17.0][android_sdk_v4.17.0]

---

### Version 0.0.1 (4th December 2018)
#### Added
- Test release of Flutter SDK.
- Package available at: https://pub.dartlang.org/packages/adjust_sdk

#### Native SDKs
- [iOS@v4.17.0][ios_sdk_v4.17.0]
- [Android@v4.17.0][android_sdk_v4.17.0]

[ios_sdk_v4.17.0]: https://github.com/adjust/ios_sdk/tree/v4.17.0
[ios_sdk_v4.17.3]: https://github.com/adjust/ios_sdk/tree/v4.17.3
[ios_sdk_v4.18.0]: https://github.com/adjust/ios_sdk/tree/v4.18.0
[ios_sdk_v4.18.3]: https://github.com/adjust/ios_sdk/tree/v4.18.3
[ios_sdk_v4.21.0]: https://github.com/adjust/ios_sdk/tree/v4.21.0
[ios_sdk_v4.22.1]: https://github.com/adjust/ios_sdk/tree/v4.22.1
[ios_sdk_v4.23.0]: https://github.com/adjust/ios_sdk/tree/v4.23.0
[ios_sdk_v4.23.2]: https://github.com/adjust/ios_sdk/tree/v4.23.2
[ios_sdk_v4.26.1]: https://github.com/adjust/ios_sdk/tree/v4.26.1
[ios_sdk_v4.28.0]: https://github.com/adjust/ios_sdk/tree/v4.28.0
[ios_sdk_v4.29.2]: https://github.com/adjust/ios_sdk/tree/v4.29.2
[ios_sdk_v4.29.6]: https://github.com/adjust/ios_sdk/tree/v4.29.6
[ios_sdk_v4.29.7]: https://github.com/adjust/ios_sdk/tree/v4.29.7
[ios_sdk_v4.30.0]: https://github.com/adjust/ios_sdk/tree/v4.30.0
[ios_sdk_v4.31.0]: https://github.com/adjust/ios_sdk/tree/v4.31.0
[ios_sdk_v4.32.1]: https://github.com/adjust/ios_sdk/tree/v4.32.1
[ios_sdk_v4.33.2]: https://github.com/adjust/ios_sdk/tree/v4.33.2
[ios_sdk_v4.33.4]: https://github.com/adjust/ios_sdk/tree/v4.33.4
[ios_sdk_v4.34.2]: https://github.com/adjust/ios_sdk/tree/v4.34.2
[ios_sdk_v4.35.0]: https://github.com/adjust/ios_sdk/tree/v4.35.0
[ios_sdk_v4.35.1]: https://github.com/adjust/ios_sdk/tree/v4.35.1
[ios_sdk_v4.35.2]: https://github.com/adjust/ios_sdk/tree/v4.35.2
[ios_sdk_v4.36.0]: https://github.com/adjust/ios_sdk/tree/v4.36.0
[ios_sdk_v4.37.0]: https://github.com/adjust/ios_sdk/tree/v4.37.0
[ios_sdk_v4.37.1]: https://github.com/adjust/ios_sdk/tree/v4.37.1
[ios_sdk_v4.38.0]: https://github.com/adjust/ios_sdk/tree/v4.38.0

[android_sdk_v4.17.0]: https://github.com/adjust/android_sdk/tree/v4.17.0
[android_sdk_v4.18.0]: https://github.com/adjust/android_sdk/tree/v4.18.0
[android_sdk_v4.21.0]: https://github.com/adjust/android_sdk/tree/v4.21.0
[android_sdk_v4.22.0]: https://github.com/adjust/android_sdk/tree/v4.22.0
[android_sdk_v4.24.0]: https://github.com/adjust/android_sdk/tree/v4.24.0
[android_sdk_v4.24.1]: https://github.com/adjust/android_sdk/tree/v4.24.1
[android_sdk_v4.26.2]: https://github.com/adjust/android_sdk/tree/v4.26.2
[android_sdk_v4.27.0]: https://github.com/adjust/android_sdk/tree/v4.27.0
[android_sdk_v4.28.1]: https://github.com/adjust/android_sdk/tree/v4.28.1
[android_sdk_v4.28.5]: https://github.com/adjust/android_sdk/tree/v4.28.5
[android_sdk_v4.30.1]: https://github.com/adjust/android_sdk/tree/v4.30.1
[android_sdk_v4.31.0]: https://github.com/adjust/android_sdk/tree/v4.31.0
[android_sdk_v4.32.0]: https://github.com/adjust/android_sdk/tree/v4.32.0
[android_sdk_v4.33.2]: https://github.com/adjust/android_sdk/tree/v4.33.2
[android_sdk_v4.33.3]: https://github.com/adjust/android_sdk/tree/v4.33.3
[android_sdk_v4.34.0]: https://github.com/adjust/android_sdk/tree/v4.34.0
[android_sdk_v4.35.0]: https://github.com/adjust/android_sdk/tree/v4.35.0
[android_sdk_v4.35.1]: https://github.com/adjust/android_sdk/tree/v4.35.1
[android_sdk_v4.37.0]: https://github.com/adjust/android_sdk/tree/v4.37.0
[android_sdk_v4.38.0]: https://github.com/adjust/android_sdk/tree/v4.38.0
[android_sdk_v4.38.1]: https://github.com/adjust/android_sdk/tree/v4.38.1
[android_sdk_v4.38.3]: https://github.com/adjust/android_sdk/tree/v4.38.3