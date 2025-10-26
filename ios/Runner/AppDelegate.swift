// Pokud už máš AppDelegate v Swiftu, doplň kód níže. Pokud používáš Obj-C, bude potřeba přepsat do Objective-C.

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let broadcastChannel = FlutterMethodChannel(name: "com.example.replaykit/broadcast",
                                              binaryMessenger: controller.binaryMessenger)

    broadcastChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "startBroadcast" {
        BroadcastManager.shared.presentBroadcastPicker(from: controller) { (msg) in
          result(msg)
        }
      } else if call.method == "stopBroadcast" {
        BroadcastManager.shared.stopBroadcast { (msg) in
          result(msg)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}