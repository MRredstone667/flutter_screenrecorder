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
                self.showBroadcastPicker(result: result)
            case "stopRecording":
                self.stopRecording(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - Broadcast picker (inline místo BroadcastManager)
    func showBroadcastPicker(result: @escaping FlutterResult) {
        if #available(iOS 12.0, *) {
            guard let controller = window?.rootViewController else {
                result("Controller not found")
                return
            }
            
            let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 150, y: 300, width: 60, height: 60))
            picker.preferredExtension = "com.example.flutterAppAndrejs.BroadcastUploadExtension"
            picker.showsMicrophoneButton = true
            controller.view.addSubview(picker)
            
            // Automatické kliknutí
            for subview in picker.subviews {
                if let button = subview as? UIButton {
                    button.sendActions(for: .allTouchEvents)
                }
            }
            result("Picker shown")
        } else {
            result("iOS 12+ required")
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
