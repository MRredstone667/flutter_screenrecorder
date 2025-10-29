import UIKit
import Flutter
import ReplayKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var broadcastController: RPBroadcastController?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    @objc func startBroadcast() {
        RPBroadcastActivityViewController.load { broadcastAVC, error in
            if let error = error {
                print("Error loading broadcast: \(error.localizedDescription)")
                return
            }

            guard let broadcastAVC = broadcastAVC else {
                print("Broadcast Activity View Controller is nil")
                return
            }

            broadcastAVC.delegate = self
            DispatchQueue.main.async {
                if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                    rootVC.present(broadcastAVC, animated: true, completion: nil)
                }
            }
        }
    }

    @objc func stopBroadcast() {
        guard let controller = broadcastController else {
            print("No broadcast controller active")
            return
        }

        controller.finishBroadcast { error in
            if let error = error {
                print("Error stopping broadcast: \(error.localizedDescription)")
            } else {
                print("Broadcast stopped successfully.")
            }
        }
    }
}

extension AppDelegate: RPBroadcastActivityViewControllerDelegate {
    func broadcastActivityViewController(
        _ broadcastActivityViewController: RPBroadcastActivityViewController,
        didFinishWith broadcastController: RPBroadcastController?,
        error: Error?
    ) {
        broadcastActivityViewController.dismiss(animated: true) {
            if let error = error {
                print("Error finishing broadcast setup: \(error.localizedDescription)")
                return
            }

            self.broadcastController = broadcastController
            self.broadcastController?.startBroadcast { error in
                if let error = error {
                    print("Error starting broadcast: \(error.localizedDescription)")
                } else {
                    print("Broadcast started successfully!")
                }
            }
        }
    }
}
