import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Registrace všech Flutter pluginů (např. video_player, file_picker apod.)
    GeneratedPluginRegistrant.register(with: self)

    // Povolit přehrávání na pozadí (např. pro audio a video)
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("⚠️ Nelze aktivovat audio session: \(error)")
    }

    // Hotovo
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
