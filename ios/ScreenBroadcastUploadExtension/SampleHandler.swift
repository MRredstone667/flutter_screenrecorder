import ReplayKit
import AVFoundation

class SampleHandler: RPBroadcastSampleHandler {
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        // Tady můžeš přenášet snímky do hlavní appky přes App Group
    }

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        print("Broadcast started")
    }

    override func broadcastFinished() {
        print("Broadcast finished")
    }
}
