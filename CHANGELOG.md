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
- Added `setUrlStrategy` method to `AdjustConfig` class to allow selection of URL strategy for specific market.

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

[android_sdk_v4.17.0]: https://github.com/adjust/android_sdk/tree/v4.17.0
[android_sdk_v4.18.0]: https://github.com/adjust/android_sdk/tree/v4.18.0
[android_sdk_v4.21.0]: https://github.com/adjust/android_sdk/tree/v4.21.0
[android_sdk_v4.22.0]: https://github.com/adjust/android_sdk/tree/v4.22.0
[android_sdk_v4.24.0]: https://github.com/adjust/android_sdk/tree/v4.24.0
[android_sdk_v4.24.1]: https://github.com/adjust/android_sdk/tree/v4.24.1