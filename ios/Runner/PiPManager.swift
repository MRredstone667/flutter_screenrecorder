import AVKit
import UIKit

@objc class PiPManager: NSObject {
    static var pipController: AVPictureInPictureController?

    static func startPiP(view: UIView) {
        guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
        let playerLayer = AVPlayerLayer(player: AVPlayer())
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.startPictureInPicture()
    }
}
