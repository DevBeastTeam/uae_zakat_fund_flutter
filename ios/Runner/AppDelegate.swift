import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let channelName = "ae.gov.awqaf.zakat"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAouALIRFA9F4gW9fYvZjjDz4eqRDLcSck")
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
      let controller = window?.rootViewController as! FlutterViewController
            let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

            methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
                if call.method == "shareText" {
                    guard let args = call.arguments as? [String: Any],
                          let text = args["text"] as? String else {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: "Text argument is required", details: nil))
                        return
                    }
                    self?.shareText(text: text)
                    result(nil)
                } else {
                    if call.method == "getDeviceName" {
                        result(UIDevice.current.name)
                    }
                }
            }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

   private func shareText(text: String) {
          let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
          if let rootViewController = window?.rootViewController {
              rootViewController.present(activityViewController, animated: true, completion: nil)
          }
      }

}
