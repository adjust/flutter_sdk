# Adjust SDK for Flutter: Google ODM plugin

This is the Google On-Device Measurement (ODM) plugin for the [Adjust](https://adjust.com)™ SDK for Flutter. Documentation is available on our [developer docs](https://dev.adjust.com/en/sdk/flutter/plugins/google-odm).

Add it next to `adjust_sdk`, using the same version:

```yaml
dependencies:
  adjust_sdk: 5.8.0
  adjust_sdk_google_odm: 5.8.0
```

The plugin has no Dart API. On iOS it adds the native Google ODM plugin to the app, and the Adjust SDK picks it up at runtime:

- Swift Package Manager: adds the `AdjustGoogleOdm` product, which also brings the `GoogleAdsOnDeviceConversion` dependency. No Xcode project changes are needed.
- CocoaPods: adds the `Adjust/AdjustGoogleOdm` subspec, so `pod 'Adjust/AdjustGoogleOdm'` is no longer needed in the `Podfile`. `GoogleAdsOnDeviceConversion` still comes from Firebase Analytics 11.14.0 or later, or from `pod 'GoogleAdsOnDeviceConversion'` in the `Podfile`, as described in the documentation.

## License

Distributed under the [`MIT license`](LICENSE).
