import UIKit
import Flutter
import ReplayKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.replaykit/broadcast", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "startBroadcast" {
        BroadcastManager.start()
        result("started")
      } else if call.method == "stopBroadcast" {
        BroadcastManager.stop()
        result("stopped")
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// 🧩 Přidej tohle sem ↓↓↓
@objc class BroadcastManager: NSObject {
    static func start() {
        if #available(iOS 12.0, *) {
            let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            picker.preferredExtension = "com.example.flutterAppAndrejs.ScreenBroadcastUploadExtension"
            
            if let button = picker.subviews.first as? UIButton {
                button.sendActions(for: .allTouchEvents)
            }
        }
    }

    static func stop() {
        if #available(iOS 12.0, *) {
            RPScreenRecorder.shared().stopRecording { previewVC, error in
                if let error = error {
                    print("Stop recording error: \(error.localizedDescription)")
                }
            }
        }
    }
}
