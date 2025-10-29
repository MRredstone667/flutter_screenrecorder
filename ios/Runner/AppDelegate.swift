import UIKit
import Flutter
import ReplayKit
import AVKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var broadcastController: RPBroadcastActivityViewController?
    var playerViewController: AVPlayerViewController?
    var player: AVPlayer?
    var methodChannel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(name: "com.multitasking/broadcast", binaryMessenger: controller.binaryMessenger)

        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "startBroadcast":
                self?.startBroadcast(result: result)
            case "stopBroadcast":
                self?.stopBroadcast(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Start Broadcast
    private func startBroadcast(result: @escaping FlutterResult) {
        RPBroadcastActivityViewController.load { broadcastAVC, error in
            guard error == nil, let broadcastAVC = broadcastAVC else {
                result("Error: \(error?.localizedDescription ?? "Unknown")")
                return
            }

            broadcastAVC.delegate = self
            DispatchQueue.main.async {
                self.window?.rootViewController?.present(broadcastAVC, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Stop Broadcast
    private func stopBroadcast(result: @escaping FlutterResult) {
        if let controller = broadcastController {
            controller.dismiss(animated: true)
            controller.extensionBundleID = nil
        }

        if let player = player {
            player.pause()
            player.replaceCurrentItem(with: nil)
        }

        playerViewController?.dismiss(animated: true, completion: nil)
        player = nil
        playerViewController = nil
        broadcastController = nil
        result("Stopped")
    }
}

extension AppDelegate: RPBroadcastActivityViewControllerDelegate {
    func broadcastActivityViewController(
        _ broadcastActivityViewController: RPBroadcastActivityViewController,
        didFinishWith broadcastController: RPBroadcastController?, error: Error?
    ) {
        broadcastActivityViewController.dismiss(animated: true) {
            guard error == nil, let controller = broadcastController else {
                print("Broadcast start failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            controller.startBroadcast { broadcastError in
                if let broadcastError = broadcastError {
                    print("Broadcast start error: \(broadcastError.localizedDescription)")
                    return
                }

                self.broadcastController = controller
                self.startLivePreview()
            }
        }
    }

    private func startLivePreview() {
        guard let url = URL(string: "rtmp://localhost/live") else { return }
        player = AVPlayer(url: url)

        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.allowsPictureInPicturePlayback = true
        playerViewController?.player?.play()

        if let pvc = playerViewController {
            window?.rootViewController?.present(pvc, animated: true, completion: nil)
        }
    }
}
