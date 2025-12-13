import UIKit
import AVKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var pipController: AVPictureInPictureController?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let pipChannel = FlutterMethodChannel(name: "com.yourapp.pip",
                                          binaryMessenger: controller.binaryMessenger)

    pipChannel.setMethodCallHandler { call, result in
      if call.method == "playVideoInPiP",
         let args = call.arguments as? [String: String],
         let path = args["path"] {
        self.startPiPVideo(path: path)
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func startPiPVideo(path: String) {
    guard let url = URL(string: path) ?? URL(fileURLWithPath: path) else { return }

    let player = AVPlayer(url: url)
    let vc = AVPlayerViewController()
    vc.player = player
    vc.allowsPictureInPicturePlayback = true
    vc.player?.play()

    if AVPictureInPictureController.isPictureInPictureSupported(),
       let layer = vc.playerLayer {
      pipController = AVPictureInPictureController(playerLayer: layer)
      pipController?.startPictureInPicture()
    }
  }
}
