import UIKit
import AdjustSdk
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let url = launchOptions?[.url] as? URL {
        Adjust.processDeeplink(ADJDeeplink(deeplink: url)!)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NSLog("Scheme based deep link opened an app: %@", url.absoluteString)
        // add your code below to handle deep link
        // (e.g., open deep link content)
        // url object contains the deep link

        // Call the below method to send deep link to Adjust backend
        Adjust.processDeeplink(ADJDeeplink(deeplink: url)!)
        return true
    }

override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
            NSLog("Universal link opened an app: %@", userActivity.webpageURL!.absoluteString)
            // Pass deep link to Adjust in order to potentially reattribute user.
            Adjust.processDeeplink(ADJDeeplink(deeplink: userActivity.webpageURL!)!)
        }
        return true
    }
}
