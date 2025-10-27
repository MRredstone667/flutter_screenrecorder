import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    private var broadcastManager: BroadcastManager?
    private var pipManager: PiPManager?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Inicializace Flutter
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.replaykit/broadcast",
                                           binaryMessenger: controller.binaryMessenger)

        // Inicializace managerů
        broadcastManager = BroadcastManager()
        pipManager = PiPManager()

        // Handler pro volání z Dart kódu
        channel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }

            switch call.method {
            case "startBroadcast":
                self.broadcastManager?.startBroadcast { success in
                    if success {
                        self.pipManager?.startPiP()
                        result("Broadcast started")
                    } else {
                        result(FlutterError(code: "START_FAILED",
                                            message: "Unable to start broadcast",
                                            details: nil))
                    }
                }

            case "stopBroadcast":
                self.broadcastManager?.stopBroadcast()
                self.pipManager?.stopPiP()
                result("Broadcast stopped")

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // Flutter registrace
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
