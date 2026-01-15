import SwiftUI
import AVKit

struct CompletionView: View {
    @ObservedObject var processor: VideoProcessor
    let inputURL: URL
    let outputURL: URL
    let onDismiss: () -> Void

    @State private var player: AVPlayer?
    @State private var showingComparison = false
    @State private var showingShareSheet = false
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            // Background
            Color.adaptiveBackground
                .ignoresSafeArea()

            // Confetti effect
            if showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }

            VStack(spacing: 24) {
                // Header
                HStack {
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.adaptiveText)
                            .frame(width: 44, height: 44)
                    }
                    Spacer()
                    Text("Complete")
                        .font(.headline3)
                        .foregroundColor(.adaptiveText)
                    Spacer()
                    Button("Done") {
                        onDismiss()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.electricCoral)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Success message
                VStack(spacing: 8) {
                    Text("✨")
                        .font(.system(size: 48))

                    Text("You look radiant!")
                        .font(.headline2)
                        .foregroundStyle(LinearGradient.brand)
                }

                // Video Preview
                VivaraPreviewCard {
                    ZStack {
                        Color.black

                        VideoPlayerView(player: player)
                            .cornerRadius(16)
                            .padding(8)

                        // Play button overlay when paused
                        Button {
                            togglePlayback()
                        } label: {
                            Image(systemName: "play.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.white)
                                .opacity(0.8)
                        }
                    }
                    .frame(height: 240)
                }
                .padding(.horizontal, 20)

                // Compare button
                Button {
                    showingComparison = true
                } label: {
                    HStack {
                        Image(systemName: "rectangle.on.rectangle")
                        Text("Compare with Original")
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.vividPurple)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.vividPurple.opacity(0.1))
                    .cornerRadius(20)
                }

                Spacer()

                // Share options
                VStack(spacing: 16) {
                    Text("SHARE YOUR MOMENT")
                        .font(.labelSmall)
                        .foregroundColor(.adaptiveSecondaryText)
                        .tracking(1)

                    HStack(spacing: 16) {
                        ShareOptionButton(title: "Save", icon: "square.and.arrow.down") {
                            saveToPhotos()
                        }

                        ShareOptionButton(title: "Share", icon: "square.and.arrow.up") {
                            showingShareSheet = true
                        }

                        ShareOptionButton(title: "Copy", icon: "doc.on.doc") {
                            copyToClipboard()
                        }

                        ShareOptionButton(title: "More", icon: "ellipsis") {
                            showingShareSheet = true
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Create another button
                VivaraPrimaryButton("Create Another", icon: "sparkles") {
                    onDismiss()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            setupPlayer()
            triggerConfetti()
        }
        .onDisappear {
            player?.pause()
        }
        .fullScreenCover(isPresented: $showingComparison) {
            ComparisonView(
                originalURL: inputURL,
                processedURL: outputURL,
                onDismiss: { showingComparison = false }
            )
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [outputURL])
        }
    }

    private func setupPlayer() {
        let avPlayer = AVPlayer(url: outputURL)
        avPlayer.isMuted = false
        self.player = avPlayer

        // Loop video
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: avPlayer.currentItem,
            queue: .main
        ) { _ in
            avPlayer.seek(to: .zero)
            avPlayer.play()
        }

        avPlayer.play()
    }

    private func togglePlayback() {
        guard let player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            player.play()
        }
        HapticManager.impact(.light)
    }

    private func saveToPhotos() {
        HapticManager.impact(.medium)
        Task {
            await processor.saveToPhotos()
            HapticManager.notification(.success)
        }
    }

    private func copyToClipboard() {
        HapticManager.impact(.light)
        UIPasteboard.general.url = outputURL
        HapticManager.notification(.success)
    }

    private func triggerConfetti() {
        showConfetti = true
        HapticManager.notification(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showConfetti = false
            }
        }
    }
}

// MARK: - Confetti View

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
                animateParticles(in: geometry.size)
            }
        }
    }

    private func createParticles(in size: CGSize) {
        let colors: [Color] = [.electricCoral, .vividPurple, .luminousCyan, .yellow, .green]

        particles = (0..<50).map { _ in
            ConfettiParticle(
                position: CGPoint(x: CGFloat.random(in: 0...size.width), y: -20),
                color: colors.randomElement() ?? .electricCoral,
                size: CGFloat.random(in: 6...12),
                opacity: 1.0
            )
        }
    }

    private func animateParticles(in size: CGSize) {
        for i in particles.indices {
            let delay = Double.random(in: 0...0.5)
            let duration = Double.random(in: 2...3)

            withAnimation(.easeOut(duration: duration).delay(delay)) {
                particles[i].position = CGPoint(
                    x: particles[i].position.x + CGFloat.random(in: -100...100),
                    y: size.height + 50
                )
                particles[i].opacity = 0
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    let size: CGFloat
    var opacity: Double
}

// MARK: - Preview

#Preview {
    CompletionView(
        processor: VideoProcessor(),
        inputURL: URL(fileURLWithPath: "/tmp/input.mov"),
        outputURL: URL(fileURLWithPath: "/tmp/output.mov")
    ) {
        print("Dismissed")
    }
}
