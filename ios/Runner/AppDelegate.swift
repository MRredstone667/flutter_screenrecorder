import UIKit
import Flutter
import ReplayKit
import AVKit

// BroadcastManager
@objc class BroadcastManager: NSObject {
    static func startBroadcast() {
        let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        picker.preferredExtension = "com.example.flutterAppAndrejs.BroadcastUploadExtension"
        if let button = picker.subviews.first as? UIButton {
            button.sendActions(for: .allTouchEvents)
        }
    }
}

// PiPManager
@objc class PiPManager: NSObject {
    static var pipController: AVPictureInPictureController?

    static func startPiP(view: UIView) {
        guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
        let playerLayer = AVPlayerLayer(player: AVPlayer())
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.startPictureInPicture()
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.flutterAppAndrejs/native", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "startBroadcast" {
        BroadcastManager.startBroadcast()
        result(nil)
      } else if call.method == "startPiP" {
        PiPManager.startPiP(view: controller.view)
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
