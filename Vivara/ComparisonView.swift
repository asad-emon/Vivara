import SwiftUI
import AVKit

struct ComparisonView: View {
    let originalURL: URL
    let processedURL: URL
    let onDismiss: () -> Void

    @State private var showingOriginal = false
    @State private var player: AVPlayer?
    @State private var originalPlayer: AVPlayer?
    @State private var isPlaying = true
    @State private var sliderPosition: CGFloat = 0.5

    var body: some View {
        NavigationStack {
            ZStack {
                // Cinematic black background
                Color.black.ignoresSafeArea()

                GeometryReader { geometry in
                    ZStack {
                        // Processed video (right side / bottom layer)
                        VideoPlayerView(player: player)

                        // Original video with mask (left side)
                        VideoPlayerView(player: originalPlayer)
                            .mask(
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .frame(width: geometry.size.width * sliderPosition)
                                    Color.clear
                                }
                            )

                        // Divider line
                        Rectangle()
                            .fill(LinearGradient.brand)
                            .frame(width: 4)
                            .position(x: geometry.size.width * sliderPosition, y: geometry.size.height / 2)
                            .shadow(color: .electricCoral.opacity(0.5), radius: 8)

                        // Drag handle
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .overlay(
                                HStack(spacing: 2) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 10, weight: .bold))
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 10, weight: .bold))
                                }
                                .foregroundColor(.charcoalGray)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 8)
                            .position(x: geometry.size.width * sliderPosition, y: geometry.size.height / 2)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let newPosition = value.location.x / geometry.size.width
                                        sliderPosition = max(0.1, min(0.9, newPosition))
                                        HapticManager.selection()
                                    }
                            )

                        // Labels
                        VStack {
                            HStack {
                                // Original label
                                Text("ORIGINAL")
                                    .font(.captionMedium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(8)
                                    .padding(16)

                                Spacer()

                                // Processed label
                                Text("PROCESSED")
                                    .font(.captionMedium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        LinearGradient.brand.opacity(0.8)
                                    )
                                    .cornerRadius(8)
                                    .padding(16)
                            }

                            Spacer()
                        }
                    }
                }

                // Bottom controls
                VStack {
                    Spacer()

                    VStack(spacing: 16) {
                        // Play/Pause button
                        Button {
                            togglePlayback()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                Text(isPlaying ? "Pause" : "Play")
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(.ultraThinMaterial)
                            .cornerRadius(24)
                        }

                        // Instruction
                        Text("Drag to compare")
                            .font(.captionMedium)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("Compare")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        player?.pause()
                        originalPlayer?.pause()
                        onDismiss()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.electricCoral)
                }
            }
            .onAppear {
                setupPlayers()
            }
            .onDisappear {
                player?.pause()
                originalPlayer?.pause()
            }
        }
    }

    private func setupPlayers() {
        // Setup processed video player
        let processedPlayer = AVPlayer(url: processedURL)
        processedPlayer.isMuted = false
        self.player = processedPlayer

        // Setup original video player
        let origPlayer = AVPlayer(url: originalURL)
        origPlayer.isMuted = true
        self.originalPlayer = origPlayer

        // Loop both videos
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: processedPlayer.currentItem,
            queue: .main
        ) { _ in
            processedPlayer.seek(to: .zero)
            origPlayer.seek(to: .zero)
            processedPlayer.play()
            origPlayer.play()
        }

        // Start playback
        processedPlayer.play()
        origPlayer.play()

        // Sync players periodically
        syncPlayers()
    }

    private func togglePlayback() {
        HapticManager.impact(.light)
        if isPlaying {
            player?.pause()
            originalPlayer?.pause()
        } else {
            player?.play()
            originalPlayer?.play()
        }
        isPlaying.toggle()
    }

    private func syncPlayers() {
        guard let player, let originalPlayer else { return }

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            guard self.isPlaying else { return }
            let currentTime = player.currentTime()
            let originalTime = originalPlayer.currentTime()

            let diff = abs(currentTime.seconds - originalTime.seconds)
            if diff > 0.1 {
                originalPlayer.seek(to: currentTime, toleranceBefore: .zero, toleranceAfter: .zero)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ComparisonView(
        originalURL: URL(fileURLWithPath: "/tmp/test.mov"),
        processedURL: URL(fileURLWithPath: "/tmp/test.mov"),
        onDismiss: {}
    )
}
