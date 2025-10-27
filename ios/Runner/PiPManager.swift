import Foundation
import AVKit
import UIKit

@objc class PiPManager: NSObject {
    static let shared = PiPManager()
    private var pipController: AVPictureInPictureController?
    private var playerLayer: AVPlayerLayer?

    func startPiP(with url: URL) {
        let player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        guard AVPictureInPictureController.isPictureInPictureSupported(),
              let layer = playerLayer else { return }

        pipController = AVPictureInPictureController(playerLayer: layer)
        player.play()
        pipController?.startPictureInPicture()
    }

    func stopPiP() {
        pipController?.stopPictureInPicture()
        pipController = nil
    }
}
