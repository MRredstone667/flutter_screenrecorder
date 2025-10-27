import ReplayKit
import Flutter

@objc class BroadcastManager: NSObject {
    static func startBroadcast() {
        let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        picker.preferredExtension = "com.example.flutterAppAndrejs.BroadcastUploadExtension"
        if let button = picker.subviews.first as? UIButton {
            button.sendActions(for: .allTouchEvents)
        }
    }
}

