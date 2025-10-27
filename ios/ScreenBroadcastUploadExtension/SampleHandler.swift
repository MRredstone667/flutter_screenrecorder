import ReplayKit
import UIKit

class SampleHandler: RPBroadcastSampleHandler {
    let appGroupID = "group.com.yourcompany.flutter_screenrecorder"
    let filename = "latest.jpg"

    func sharedURL() -> URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?.appendingPathComponent(filename)
    }

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        print("broadcastStarted")
    }

    override func broadcastPaused() {
        print("broadcastPaused")
    }

    override func broadcastResumed() {
        print("broadcastResumed")
    }

    override func broadcastFinished() {
        print("broadcastFinished")
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        guard sampleBufferType == .video else { return }

        // Convert CMSampleBuffer -> UIImage -> JPEG Data -> write to App Group file
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)

        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)

        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            if let jpegData = uiImage.jpegData(compressionQuality: 0.6), let url = sharedURL() {
                do {
                    try jpegData.write(to: url, options: .atomic)
                } catch {
                    print("Failed to write shared frame: \(error)")
                }
            }
        }

        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
    }
}