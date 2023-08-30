
import UIKit
import Flutter
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
//    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
func application(
          _ app: UIApplication,
          open url: URL,
          options: [UIApplication.OpenURLOptionsKey : Any] = [:]
      ) -> Bool {
          ApplicationDelegate.shared.application(
              app,
              open: url,
              sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
              annotation: options[UIApplication.OpenURLOptionsKey.annotation]
          )
          return true
      }
//private func registerPlugins(registry: FlutterPluginRegistry) {
//          if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
//             FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
//          }
//      }
