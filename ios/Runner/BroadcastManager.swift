import ReplayKit
import UIKit

class BroadcastManager: NSObject {
    static let shared = BroadcastManager()
    private var picker: RPSystemBroadcastPickerView?

    func showPicker(in viewController: UIViewController) {
        if #available(iOS 12.0, *) {
            let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 100, y: 200, width: 60, height: 60))
            picker.preferredExtension = "com.example.flutterAppAndrejs.BroadcastUploadExtension"
            picker.showsMicrophoneButton = true
            self.picker = picker
            viewController.view.addSubview(picker)

            // Automatické kliknutí na tlačítko
            for subview in picker.subviews {
                if let button = subview as? UIButton {
                    button.sendActions(for: .allTouchEvents)
                }
            }
        }
    }
}
