import ReplayKit

// Tento soubor je součástí Broadcast Upload Extension targetu.
// Zde přijímáš sampleBuffer (video/audio) a obvykle je odesíláš na server.

class SampleHandler: RPBroadcastSampleHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // Called when the user starts the broadcast. Set up connections to server here.
        print("broadcastStarted")
    }

    override func broadcastPaused() {
        // User has requested to pause
        print("broadcastPaused")
    }

    override func broadcastResumed() {
        print("broadcastResumed")
    }

    override func broadcastFinished() {
        // Clean up
        print("broadcastFinished")
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case .video:
            // Here you receive CMSampleBuffer with video frames
            // You could encode and send them to your server.
            // For debugging, we just log
            print("video frame received")
        case .audioApp:
            print("audio app frame")
        case .audioMic:
            print("audio mic frame")
        @unknown default:
            break
        }
    }
}