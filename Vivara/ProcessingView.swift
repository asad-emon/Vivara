import SwiftUI

struct ProcessingView: View {
    @ObservedObject var processor: VideoProcessor
    let onComplete: () -> Void

    @State private var currentTip = ProcessingTip.random()
    @State private var tipTimer: Timer?
    @State private var startTime: Date?
    @State private var estimatedTimeRemaining: String = ""

    var body: some View {
        ZStack {
            // Background
            Color.adaptiveBackground
                .ignoresSafeArea()

            VStack(spacing: 32) {
                // Header
                HStack {
                    Button {
                        processor.cancelProcessing()
                        onComplete()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.adaptiveText)
                            .frame(width: 44, height: 44)
                    }
                    Spacer()
                    Text("Processing")
                        .font(.headline3)
                        .foregroundColor(.adaptiveText)
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer()

                // Preview Card
                VivaraPreviewCard {
                    ZStack {
                        Color.adaptiveSecondaryBackground.opacity(0.5)

                        if let preview = processor.previewImage ?? processor.thumbnail {
                            Image(uiImage: preview)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(16)
                                .padding(12)
                        }

                        // Processing overlay
                        Color.black.opacity(0.3)
                            .cornerRadius(24)
                    }
                    .frame(height: 240)
                }
                .padding(.horizontal, 20)

                // Status message
                VStack(spacing: 8) {
                    Text(statusEmoji)
                        .font(.system(size: 32))
                        .pulsing()

                    Text(processor.statusMessage ?? "Preparing...")
                        .font(.bodyLarge)
                        .foregroundColor(.adaptiveText)
                }

                // Progress section
                VStack(spacing: 16) {
                    VivaraProgressBar(progress: processor.progress)

                    HStack {
                        Text("\(Int(processor.progress * 100))%")
                            .font(.headline2)
                            .foregroundStyle(LinearGradient.brand)

                        Spacer()

                        if !estimatedTimeRemaining.isEmpty {
                            Text(estimatedTimeRemaining)
                                .font(.bodySmall)
                                .foregroundColor(.adaptiveSecondaryText)
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                // Tip section
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.electricCoral)
                        Text("Tip")
                            .font(.captionMedium)
                            .foregroundColor(.adaptiveSecondaryText)
                    }

                    Text(currentTip)
                        .font(.bodySmall)
                        .foregroundColor(.adaptiveText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            startTime = Date()
            startTipRotation()
        }
        .onDisappear {
            tipTimer?.invalidate()
        }
        .onChange(of: processor.progress) { _, newProgress in
            updateETA(progress: newProgress)
            if newProgress >= 1.0 {
                HapticManager.notification(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()
                }
            }
        }
    }

    private var statusEmoji: String {
        if processor.progress < 0.3 {
            return "🎬"
        } else if processor.progress < 0.6 {
            return "✨"
        } else if processor.progress < 0.9 {
            return "🌟"
        } else {
            return "🎉"
        }
    }

    private func startTipRotation() {
        tipTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                currentTip = ProcessingTip.random()
            }
        }
    }

    private func updateETA(progress: Double) {
        guard let startTime, progress > 0.05 else {
            estimatedTimeRemaining = ""
            return
        }

        let elapsed = Date().timeIntervalSince(startTime)
        let totalEstimated = elapsed / progress
        let remaining = totalEstimated - elapsed

        if remaining < 60 {
            estimatedTimeRemaining = "\(Int(remaining))s remaining"
        } else {
            let minutes = Int(remaining / 60)
            let seconds = Int(remaining.truncatingRemainder(dividingBy: 60))
            estimatedTimeRemaining = "\(minutes)m \(seconds)s remaining"
        }
    }
}

// MARK: - Preview

#Preview {
    ProcessingView(processor: VideoProcessor()) {
        print("Complete")
    }
}
