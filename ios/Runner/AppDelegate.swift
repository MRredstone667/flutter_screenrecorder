import UIKit
import Flutter
import ReplayKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  var recorder = RPScreenRecorder.shared()
  var isRecording = false
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.flutterAppAndrejs/native", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

      switch call.method {
      case "startRecording":
        self.startRecording(result: result)
      case "stopRecording":
        self.stopRecording(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func startRecording(result: @escaping FlutterResult) {
    if #available(iOS 12.0, *) {
      recorder.startRecording { error in
        if let error = error {
          result("Error starting recording: \(error.localizedDescription)")
        } else {
          self.isRecording = true
          result("Recording started")
        }
      }
    } else {
      result("Not supported on iOS < 12")
    }
  }

  func stopRecording(result: @escaping FlutterResult) {
    if #available(iOS 12.0, *) {
      recorder.stopRecording { preview, error in
        if let error = error {
          result("Error stopping recording: \(error.localizedDescription)")
          return
        }
        if let preview = preview {
          preview.previewControllerDelegate = self
          self.window?.rootViewController?.present(preview, animated: true, completion: nil)
          self.isRecording = false
          result("Recording stopped")
        }
      }
    } else {
      result("Not supported on iOS < 12")
    }
  }
}

extension AppDelegate: RPPreviewViewControllerDelegate {
  func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
    previewController.dismiss(animated: true, completion: nil)
  }
}
