import UIKit
import Flutter
import ReplayKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var screenRecorder = RPScreenRecorder.shared()
    var isRecording = false

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let broadcastChannel = FlutterMethodChannel(name: "com.example.flutterAppAndrejs/broadcast",
                                                    binaryMessenger: controller.binaryMessenger)
        
        broadcastChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "startBroadcast":
                self.startRecording(result: result)
            case "stopBroadcast":
                self.stopRecording(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func startRecording(result: @escaping FlutterResult) {
        if screenRecorder.isAvailable && !isRecording {
            screenRecorder.startRecording { error in
                if let error = error {
                    result(FlutterError(code: "START_ERROR", message: error.localizedDescription, details: nil))
                } else {
                    self.isRecording = true
                    result(nil)
                }
            }
        } else {
            result(FlutterError(code: "UNAVAILABLE", message: "Screen recorder not available", details: nil))
        }
    }

    func stopRecording(result: @escaping FlutterResult) {
        if isRecording {
            screenRecorder.stopRecording { previewVC, error in
                if let error = error {
                    result(FlutterError(code: "STOP_ERROR", message: error.localizedDescription, details: nil))
                } else {
                    self.isRecording = false
                    result(nil)
                }
            }
        } else {
            result(FlutterError(code: "NOT_RECORDING", message: "Not currently recording", details: nil))
        }
    }
}
