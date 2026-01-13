import Foundation
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit
import Photos
import Vision
import os.log

private let logger = Logger(subsystem: "com.vivara.app", category: "VideoProcessor")

@MainActor
class VideoProcessor: ObservableObject {
    @Published var inputURL: URL?
    @Published var outputURL: URL?
    @Published var thumbnail: UIImage?
    @Published var previewImage: UIImage?
    @Published var isProcessing = false
    @Published var progress: Double = 0
    @Published var statusMessage: String?
    @Published var depthThreshold: Double = 0.5 {
        didSet {
            updatePreview()
        }
    }
    @Published var showingCompletionAlert = false
    @Published var showingShareSheet = false
    @Published var showingComparison = false

    private var originalThumbnail: CIImage?
    private var exportSession: AVAssetExportSession?
    private var progressTimer: Timer?
    private let ciContext = CIContext()

    func loadVideo(from url: URL) {
        logger.info("Loading video from: \(url.path)")
        inputURL = url
        statusMessage = "Loaded: \(url.lastPathComponent)"
        generateThumbnail(from: url)
    }

    private func generateThumbnail(from url: URL) {
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 600, height: 600)

        Task {
            do {
                let (cgImage, _) = try await generator.image(at: .zero)
                originalThumbnail = CIImage(cgImage: cgImage)
                thumbnail = UIImage(cgImage: cgImage)
                updatePreview()
            } catch {
                print("Thumbnail generation failed: \(error)")
            }
        }
    }

    private func updatePreview() {
        guard let original = originalThumbnail else {
            previewImage = thumbnail
            return
        }

        // Run segmentation on background thread
        Task.detached { [weak self, depthThreshold] in
            guard let self else { return }

            let extent = original.extent

            // Create grayscale version
            let grayscaleFilter = CIFilter.colorControls()
            grayscaleFilter.inputImage = original
            grayscaleFilter.saturation = 0

            guard let grayscaleImage = grayscaleFilter.outputImage else {
                await MainActor.run { self.previewImage = self.thumbnail }
                return
            }

            // Use Vision to segment people
            let segmentationRequest = VNGeneratePersonSegmentationRequest()
            segmentationRequest.qualityLevel = .balanced
            segmentationRequest.outputPixelFormat = kCVPixelFormatType_OneComponent8

            let handler = VNImageRequestHandler(ciImage: original, options: [:])

            do {
                try handler.perform([segmentationRequest])

                guard let result = segmentationRequest.results?.first else {
                    // No person detected - show grayscale
                    if let cgImage = self.ciContext.createCGImage(grayscaleImage, from: extent) {
                        await MainActor.run { self.previewImage = UIImage(cgImage: cgImage) }
                    }
                    return
                }

                let maskBuffer = result.pixelBuffer

                // Convert mask to CIImage and scale
                var maskImage = CIImage(cvPixelBuffer: maskBuffer)
                let scaleX = extent.width / maskImage.extent.width
                let scaleY = extent.height / maskImage.extent.height
                maskImage = maskImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

                // Adjust mask based on threshold
                let thresholdFilter = CIFilter.colorMatrix()
                thresholdFilter.inputImage = maskImage
                let factor = Float(0.5 + depthThreshold * 1.5)
                thresholdFilter.rVector = CIVector(x: CGFloat(factor), y: 0, z: 0, w: 0)
                thresholdFilter.gVector = CIVector(x: CGFloat(factor), y: 0, z: 0, w: 0)
                thresholdFilter.bVector = CIVector(x: CGFloat(factor), y: 0, z: 0, w: 0)
                thresholdFilter.aVector = CIVector(x: 0, y: 0, z: 0, w: 1)

                let adjustedMask = thresholdFilter.outputImage ?? maskImage

                // Blend
                let blendFilter = CIFilter.blendWithMask()
                blendFilter.inputImage = original
                blendFilter.backgroundImage = grayscaleImage
                blendFilter.maskImage = adjustedMask.cropped(to: extent)

                if let output = blendFilter.outputImage?.cropped(to: extent),
                   let cgImage = self.ciContext.createCGImage(output, from: extent) {
                    await MainActor.run { self.previewImage = UIImage(cgImage: cgImage) }
                }

            } catch {
                logger.error("Preview segmentation failed: \(error.localizedDescription)")
                await MainActor.run { self.previewImage = self.thumbnail }
            }
        }
    }

    func processVideo() async {
        guard let inputURL else {
            logger.error("No input URL set")
            return
        }

        logger.info("Starting video processing for: \(inputURL.lastPathComponent)")
        isProcessing = true
        progress = 0
        statusMessage = "Preparing..."

        let threshold = depthThreshold

        do {
            let result = try await processWithExportSession(inputURL: inputURL, threshold: threshold)
            outputURL = result
            logger.info("Processing complete. Output: \(result.path)")
            statusMessage = "Complete!"
            showingCompletionAlert = true
        } catch {
            logger.error("Processing failed: \(error.localizedDescription)")
            statusMessage = "Error: \(error.localizedDescription)"
        }

        isProcessing = false
        progressTimer?.invalidate()
        progressTimer = nil
    }

    func saveToPhotos() async {
        guard let outputURL else { return }

        do {
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
            }
            statusMessage = "Saved to Photos!"
        } catch {
            statusMessage = "Failed to save: \(error.localizedDescription)"
        }
    }

    private func processWithExportSession(inputURL: URL, threshold: Double) async throws -> URL {
        logger.info("Creating asset...")
        let asset = AVURLAsset(url: inputURL)

        // Load tracks
        logger.info("Loading tracks...")
        guard let videoTrack = try await asset.loadTracks(withMediaType: .video).first else {
            throw ProcessingError.noVideoTrack
        }

        let duration = try await asset.load(.duration)
        let naturalSize = try await videoTrack.load(.naturalSize)
        let transform = try await videoTrack.load(.preferredTransform)

        // Calculate correct size
        let transformedSize = naturalSize.applying(transform)
        let renderSize = CGSize(width: abs(transformedSize.width), height: abs(transformedSize.height))

        logger.info("Video size: \(naturalSize.width)x\(naturalSize.height), render size: \(renderSize.width)x\(renderSize.height)")

        // Create video composition
        let composition = AVMutableVideoComposition(asset: asset) { request in
            self.applyFilter(request: request, threshold: threshold)
        }
        composition.renderSize = renderSize

        // Get frame rate
        let frameRate = try await videoTrack.load(.nominalFrameRate)
        composition.frameDuration = CMTime(value: 1, timescale: CMTimeScale(frameRate))

        logger.info("Composition configured: \(renderSize.width)x\(renderSize.height) @ \(frameRate) fps")

        // Setup output URL
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mov")
        try? FileManager.default.removeItem(at: outputURL)

        // Create export session
        logger.info("Creating export session...")
        guard let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            throw ProcessingError.exportSessionCreationFailed
        }

        session.outputURL = outputURL
        session.outputFileType = .mov
        session.videoComposition = composition
        session.shouldOptimizeForNetworkUse = false

        self.exportSession = session

        // Start progress monitoring
        await MainActor.run {
            self.statusMessage = "Processing..."
            self.startProgressMonitoring()
        }

        logger.info("Starting export...")

        // Export
        await session.export()

        logger.info("Export finished with status: \(session.status.rawValue)")

        switch session.status {
        case .completed:
            return outputURL
        case .failed:
            logger.error("Export failed: \(session.error?.localizedDescription ?? "unknown")")
            throw ProcessingError.exportFailed(session.error)
        case .cancelled:
            throw ProcessingError.exportCancelled
        default:
            throw ProcessingError.exportFailed(nil)
        }
    }

    private nonisolated func applyFilter(request: AVAsynchronousCIImageFilteringRequest, threshold: Double) {
        let source = request.sourceImage
        let extent = source.extent

        // Create grayscale version
        let grayscaleFilter = CIFilter.colorControls()
        grayscaleFilter.inputImage = source
        grayscaleFilter.saturation = 0

        guard let grayscaleImage = grayscaleFilter.outputImage else {
            request.finish(with: source, context: nil)
            return
        }

        // Use Vision to segment people
        let segmentationRequest = VNGeneratePersonSegmentationRequest()
        segmentationRequest.qualityLevel = .balanced
        segmentationRequest.outputPixelFormat = kCVPixelFormatType_OneComponent8

        let handler = VNImageRequestHandler(ciImage: source, options: [:])

        do {
            try handler.perform([segmentationRequest])

            guard let result = segmentationRequest.results?.first else {
                // No person detected - return grayscale
                request.finish(with: grayscaleImage, context: nil)
                return
            }

            let maskBuffer = result.pixelBuffer

            // Convert mask to CIImage and scale to match source
            var maskImage = CIImage(cvPixelBuffer: maskBuffer)

            // Scale mask to match source extent
            let scaleX = extent.width / maskImage.extent.width
            let scaleY = extent.height / maskImage.extent.height
            maskImage = maskImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

            // Apply threshold to mask (expand/contract the mask based on threshold)
            // threshold 0 = more grayscale, threshold 1 = more color
            let thresholdFilter = CIFilter.colorMatrix()
            thresholdFilter.inputImage = maskImage
            // Adjust the mask intensity based on threshold
            let factor = Float(0.5 + threshold * 1.5) // Range: 0.5 to 2.0
            thresholdFilter.rVector = CIVector(x: CGFloat(factor), y: 0, z: 0, w: 0)
            thresholdFilter.gVector = CIVector(x: CGFloat(factor), y: 0, z: 0, w: 0)
            thresholdFilter.bVector = CIVector(x: CGFloat(factor), y: 0, z: 0, w: 0)
            thresholdFilter.aVector = CIVector(x: 0, y: 0, z: 0, w: 1)

            let adjustedMask = thresholdFilter.outputImage ?? maskImage

            // Blend: color where mask is white (person), grayscale where black (background)
            let blendFilter = CIFilter.blendWithMask()
            blendFilter.inputImage = source
            blendFilter.backgroundImage = grayscaleImage
            blendFilter.maskImage = adjustedMask.cropped(to: extent)

            if let output = blendFilter.outputImage?.cropped(to: extent) {
                request.finish(with: output, context: nil)
            } else {
                request.finish(with: grayscaleImage, context: nil)
            }

        } catch {
            logger.error("Vision segmentation failed: \(error.localizedDescription)")
            // Fallback to grayscale
            request.finish(with: grayscaleImage, context: nil)
        }
    }

    private func startProgressMonitoring() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self, let session = self.exportSession else { return }
            Task { @MainActor in
                self.progress = Double(session.progress)
                if session.progress > 0 {
                    logger.info("Export progress: \(Int(session.progress * 100))%")
                }
            }
        }
    }

    func cancelProcessing() {
        exportSession?.cancelExport()
        progressTimer?.invalidate()
        progressTimer = nil
    }
}

enum ProcessingError: LocalizedError {
    case noVideoTrack
    case exportSessionCreationFailed
    case exportFailed(Error?)
    case exportCancelled

    var errorDescription: String? {
        switch self {
        case .noVideoTrack:
            return "No video track found in file"
        case .exportSessionCreationFailed:
            return "Failed to create export session"
        case .exportFailed(let error):
            return "Export failed: \(error?.localizedDescription ?? "unknown")"
        case .exportCancelled:
            return "Export was cancelled"
        }
    }
}
