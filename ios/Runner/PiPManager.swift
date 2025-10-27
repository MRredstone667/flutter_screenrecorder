import Foundation
import AVFoundation
import AVKit
import UIKit

@available(iOS 15.0, *)
class PiPManager: NSObject {
    static let shared = PiPManager()
    private var displayLayer: AVSampleBufferDisplayLayer?
    private var pipController: AVPictureInPictureController?
    private var timer: Timer?
    let appGroupID = "group.com.yourcompany.flutter_screenrecorder"
    let filename = "latest.jpg"

    func startPiP(in parentView: UIView) {
        // Setup display layer
        displayLayer = AVSampleBufferDisplayLayer()
        displayLayer?.videoGravity = .resizeAspect
        displayLayer?.frame = parentView.bounds
        parentView.layer.addSublayer(displayLayer!)

        // Setup PiP (use contentSource if available, fallback to playerLayer)
        if #available(iOS 16.0, *) {
            let contentSource = AVSampleBufferDisplayLayerContentSource(sampleBufferDisplayLayer: displayLayer!)
            pipController = try? AVPictureInPictureController(contentSource: contentSource)
        } else if AVPictureInPictureController.isPictureInPictureSupported() {
            pipController = AVPictureInPictureController(contentSource: AVPictureInPictureController.ContentSource(sampleBufferDisplayLayer: displayLayer!))
        }

        // Start periodic reader
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.readFrameAndEnqueue()
        })

        // Start PiP
        if let pip = pipController, !pip.isPictureInPictureActive {
            pip.startPictureInPicture()
        }
    }

    func stopPiP() {
        timer?.invalidate()
        timer = nil
        if let pip = pipController, pip.isPictureInPictureActive {
            pip.stopPictureInPicture()
        }
        displayLayer?.removeFromSuperlayer()
        displayLayer = nil
        pipController = nil
    }

    private func sharedURL() -> URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?.appendingPathComponent(filename)
    }

    private func readFrameAndEnqueue() {
        guard let url = sharedURL(), FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            let data = try Data(contentsOf: url)
            guard let image = UIImage(data: data) else { return }
            guard let sampleBuffer = PiPManager.sampleBufferFromUIImage(image: image) else { return }
            // Enqueue sample buffer
            displayLayer?.enqueue(sampleBuffer)
        } catch {
            print("Failed to read shared frame: \(error)")
        }
    }

    // Helper: create CMSampleBuffer from UIImage via CVPixelBuffer
    private static func sampleBufferFromUIImage(image: UIImage) -> CMSampleBuffer? {
        guard let cgImage = image.cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height

        var pixelBuffer: CVPixelBuffer?
        let attrs: [CFString:Any] = [kCVPixelBufferCGImageCompatibilityKey: true, kCVPixelBufferCGBitmapContextCompatibilityKey: true]
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs as CFDictionary, &pixelBuffer)
        guard status == kCVReturnSuccess, let pxBuf = pixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(pxBuf, [])
        let pxData = CVPixelBufferGetBaseAddress(pxBuf)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pxData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pxBuf), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pxBuf, [])

        var timimg = CMSampleTimingInfo(duration: CMTime(value: 1, timescale: 30), presentationTimeStamp: CMTime.invalid, decodeTimeStamp: CMTime.invalid)
        var videoInfo: CMVideoFormatDescription?
        CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault, imageBuffer: pxBuf, formatDescriptionOut: &videoInfo)
        var sampleBuffer: CMSampleBuffer?
        CMSampleBufferCreateReadyWithImageBuffer(allocator: kCFAllocatorDefault, imageBuffer: pxBuf, formatDescription: videoInfo!, sampleTiming: &timimg, sampleBufferOut: &sampleBuffer)
        return sampleBuffer
    }
}