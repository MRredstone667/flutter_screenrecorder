import Foundation
import ReplayKit

@objc class BroadcastManager: NSObject {
    static let shared = BroadcastManager()
    private var broadcastController: RPBroadcastController?

    func startBroadcast() {
        RPBroadcastActivityViewController.load { viewController, error in
            guard let vc = viewController, error == nil else {
                print("Failed to load broadcast activity view controller: \(String(describing: error))")
                return
            }

            vc.delegate = self
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.present(vc, animated: true, completion: nil)
            }
        }
    }

    func stopBroadcast() {
        broadcastController?.finishBroadcast { error in
            if let error = error {
                print("Error stopping broadcast: \(error.localizedDescription)")
            } else {
                print("Broadcast stopped successfully")
            }
        }
    }
}

extension BroadcastManager: RPBroadcastActivityViewControllerDelegate {
    func broadcastActivityViewController(
        _ broadcastActivityViewController: RPBroadcastActivityViewController,
        didFinishWith broadcastController: RPBroadcastController?, error: Error?
    ) {
        broadcastActivityViewController.dismiss(animated: true) {
            if let error = error {
                print("Error starting broadcast: \(error.localizedDescription)")
                return
            }

            self.broadcastController = broadcastController
            self.broadcastController?.startBroadcast { error in
                if let error = error {
                    print("Failed to start broadcast: \(error.localizedDescription)")
                } else {
                    print("Broadcast started successfully")
                }
            }
        }
    }
}
