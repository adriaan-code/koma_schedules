import Flutter
import UIKit
import WonderPush

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    #if DEBUG
    WonderPush.setLogging(true)
    #endif

    let bundle = Bundle.main
    let clientId = bundle.object(forInfoDictionaryKey: "WonderPushClientId") as? String
    let clientSecret = bundle.object(forInfoDictionaryKey: "WonderPushClientSecret") as? String

    if let clientId, let clientSecret, !clientId.isEmpty, !clientSecret.isEmpty {
      WonderPush.setClientId(clientId, secret: clientSecret)
    } else {
      NSLog("⚠️ WonderPush credentials are missing in Info.plist - remote push is disabled.")
    }

    WonderPush.setupDelegate(for: application)

    // Konfiguracja powiadomień dla iOS
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      WonderPush.setupDelegateForUserNotificationCenter()
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
