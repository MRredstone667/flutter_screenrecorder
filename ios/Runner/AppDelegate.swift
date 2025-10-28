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
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.replaykit/broadcast",
                                           binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "startRecording":
                self.startBroadcast(result: result)
            case "stopRecording":
                self.stopBroadcast(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    @available(iOS 12.0, *)
    func startBroadcast(result: @escaping FlutterResult) {
        if isRecording {
            result("Already recording")
            return
        }
        
        guard let controller = window?.rootViewController else {
            result("No root controller")
            return
        }
        
        let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 150, y: 300, width: 60, height: 60))
        picker.preferredExtension = "com.example.flutterAppAndrejs.BroadcastUploadExtension"
        picker.showsMicrophoneButton = true
        controller.view.addSubview(picker)
        
        // Simulace kliknutí na broadcast tlačítko
        for view in picker.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .allTouchEvents)
            }
        }
        
        isRecording = true
        result("Broadcast started")
    }

    func stopBroadcast(result: @escaping FlutterResult) {
        if #available(iOS 11.0, *) {
            recorder.stopRecording { previewVC, error in
                self.isRecording = false
                if let error = error {
                    result("Stop error: \(error.localizedDescription)")
                    return
                }
                result("Broadcast stopped")
            }
        } else {
            result("Not supported on this iOS version")
        }
    }
}
