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

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                // Processed video (bottom layer - always visible when not pressing)
                VideoPlayerView(player: player)
                    .opacity(showingOriginal ? 0 : 1)

                // Original video (top layer - visible when pressing)
                VideoPlayerView(player: originalPlayer)
                    .opacity(showingOriginal ? 1 : 0)

                // Label showing which version
                VStack {
                    HStack {
                        Text(showingOriginal ? "ORIGINAL" : "PROCESSED")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                        Spacer()
                    }
                    .padding()

                    Spacer()

                    // Hold to compare button
                    Button {
                        // Toggle play/pause on tap
                        if isPlaying {
                            player?.pause()
                            originalPlayer?.pause()
                        } else {
                            player?.play()
                            originalPlayer?.play()
                        }
                        isPlaying.toggle()
                    } label: {
                        HStack {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            Text(isPlaying ? "Pause" : "Play")
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }
                    .padding(.bottom, 8)

                    // Hold to see original
                    Text("Hold to see original")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    showingOriginal = true
                                }
                                .onEnded { _ in
                                    showingOriginal = false
                                }
                        )
                        .padding(.bottom, 30)
                }
            }
            .navigationTitle("Compare")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        player?.pause()
                        originalPlayer?.pause()
                        onDismiss()
                    }
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
        origPlayer.isMuted = true // Mute original to avoid double audio
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

        // Sync the players
        syncPlayers()
    }

    private func syncPlayers() {
        guard let player, let originalPlayer else { return }

        // Periodically sync the original player to the processed player
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            guard self.isPlaying else { return }
            let currentTime = player.currentTime()
            let originalTime = originalPlayer.currentTime()

            // If they're more than 0.1 seconds apart, sync them
            let diff = abs(currentTime.seconds - originalTime.seconds)
            if diff > 0.1 {
                originalPlayer.seek(to: currentTime, toleranceBefore: .zero, toleranceAfter: .zero)
            }
        }
    }
}

// Simple video player view using AVPlayerLayer
struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer?

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.player = player
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        uiView.player = player
    }
}

class PlayerUIView: UIView {
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.videoGravity = .resizeAspect
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    ComparisonView(
        originalURL: URL(fileURLWithPath: "/tmp/test.mov"),
        processedURL: URL(fileURLWithPath: "/tmp/test.mov"),
        onDismiss: {}
    )
}
