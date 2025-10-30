import UIKit
import Flutter
import AVFoundation  // 🔧 DŮLEŽITÉ – přidá podporu pro AVAudioSession

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Registrace všech pluginů Flutteru
    GeneratedPluginRegistrant.register(with: self)

    // Aktivace audio session (umožní přehrávání videa i po uzamčení / PiP)
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("⚠️ Nelze aktivovat audio session: \(error)")
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
