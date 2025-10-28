import UIKit
import Flutter
import ReplayKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.replaykit/broadcast",
                                           binaryMessenger: controller.binaryMessenger)
        
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
    
    // MARK: - ReplayKit
    
    func startRecording(result: @escaping FlutterResult) {
        if let controller = window?.rootViewController {
            BroadcastManager.shared.showPicker(in: controller)
            result("Opened broadcast picker")
        } else {
            result("Controller not found")
        }
    }
    
    func stopRecording(result: @escaping FlutterResult) {
        if #available(iOS 11.0, *) {
            RPScreenRecorder.shared().stopRecording { preview, error in
                if let error = error {
                    result("Error: \(error.localizedDescription)")
                    return
                }
                result("Stopped")
            }
        } else {
            result("Not supported on this iOS version")
        }
    }
}
