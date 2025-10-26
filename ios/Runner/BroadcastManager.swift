import Foundation
import ReplayKit
import UIKit

class BroadcastManager: NSObject {
  static let shared = BroadcastManager()
  private var broadcastController: RPBroadcastController?

  // Present RPBroadcastActivityViewController to let user choose your Broadcast Upload Extension
  func presentBroadcastPicker(from viewController: UIViewController, completion: @escaping (String) -> Void) {
    RPBroadcastActivityViewController.load { (broadcastAVC, error) in
      if let error = error {
        completion("Failed to load broadcast UI: \(error.localizedDescription)")
        return
      }
      guard let broadcastAVC = broadcastAVC else {
        completion("Broadcast UI not available")
        return
      }
      // present the system UI
      viewController.present(broadcastAVC, animated: true) {
        completion("Presented broadcast picker")
      }

      // when user chooses extension and taps Start, the broadcastAVC will call its completion with a RPBroadcastController
      broadcastAVC.delegate = self
    }
  }

  func stopBroadcast(completion: @escaping (String) -> Void) {
    guard let controller = broadcastController else {
      completion("No active broadcast")
      return
    }
    controller.finishBroadcast { error in
      if let error = error {
        completion("Error stopping: \(error.localizedDescription)")
      } else {
        self.broadcastController = nil
        completion("Broadcast stopped")
      }
    }
  }
}

extension BroadcastManager: RPBroadcastActivityViewControllerDelegate {
  func broadcastActivityViewController(_ broadcastActivityViewController: RPBroadcastActivityViewController, didFinishWith broadcastController: RPBroadcastController?, error: Error?) {
    broadcastActivityViewController.dismiss(animated: true)
    if let error = error {
      NSLog("Broadcast start error: \(error.localizedDescription)")
      return
    }
    self.broadcastController = broadcastController
    // broadcastController?.startBroadcast { error in ... } // not needed, start is automatic after selection
    NSLog("Broadcast started, controller received")
  }
}