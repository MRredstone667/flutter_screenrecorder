import Foundation
import ReplayKit
import Flutter

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