import SwiftUI
import PhotosUI
import AVFoundation
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var processor = VideoProcessor()
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilePicker = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Preview area
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))

                    if let preview = processor.previewImage ?? processor.thumbnail {
                        Image(uiImage: preview)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                            .padding(8)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "video.badge.plus")
                                .font(.system(size: 56))
                                .foregroundColor(.secondary)
                            Text("Select a video to process")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxHeight: 300)

                // Status
                if let status = processor.statusMessage {
                    HStack(spacing: 8) {
                        if processor.isProcessing {
                            ProgressView()
                        }
                        Text(status)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                // Progress bar
                if processor.isProcessing {
                    ProgressView(value: processor.progress)
                        .progressViewStyle(.linear)
                        .padding(.horizontal)
                }

                // Depth threshold control
                VStack(alignment: .leading, spacing: 8) {
                    Text("Depth Threshold: \(processor.depthThreshold, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Slider(value: $processor.depthThreshold, in: 0...1)
                }
                .padding(.horizontal)

                Spacer()

                // Action buttons
                VStack(spacing: 12) {
                    // Photos picker
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .videos,
                        photoLibrary: .shared()
                    ) {
                        Label("Choose from Photos", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                    // File picker
                    Button {
                        showingFilePicker = true
                    } label: {
                        Label("Choose from Files", systemImage: "folder")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                    // Process button
                    Button {
                        Task {
                            await processor.processVideo()
                        }
                    } label: {
                        Label("Process Video", systemImage: "wand.and.stars")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(processor.inputURL == nil || processor.isProcessing)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Vivara")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    await loadVideo(from: newItem)
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.movie, .video, .quickTimeMovie],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let url = urls.first {
                        // Start accessing the security-scoped resource
                        guard url.startAccessingSecurityScopedResource() else { return }
                        defer { url.stopAccessingSecurityScopedResource() }

                        // Copy to temp location for processing
                        let tempURL = FileManager.default.temporaryDirectory
                            .appendingPathComponent(url.lastPathComponent)
                        try? FileManager.default.removeItem(at: tempURL)
                        try? FileManager.default.copyItem(at: url, to: tempURL)

                        processor.loadVideo(from: tempURL)
                    }
                case .failure(let error):
                    processor.statusMessage = "Error: \(error.localizedDescription)"
                }
            }
            .alert("Processing Complete", isPresented: $processor.showingCompletionAlert) {
                Button("Compare") {
                    processor.showingComparison = true
                }
                Button("Save to Photos") {
                    Task {
                        await processor.saveToPhotos()
                    }
                }
                Button("Share") {
                    processor.showingShareSheet = true
                }
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your video has been processed successfully.")
            }
            .fullScreenCover(isPresented: $processor.showingComparison) {
                if let inputURL = processor.inputURL, let outputURL = processor.outputURL {
                    ComparisonView(
                        originalURL: inputURL,
                        processedURL: outputURL,
                        onDismiss: { processor.showingComparison = false }
                    )
                }
            }
            .sheet(isPresented: $processor.showingShareSheet) {
                if let outputURL = processor.outputURL {
                    ShareSheet(items: [outputURL])
                }
            }
        }
    }

    private func loadVideo(from item: PhotosPickerItem?) async {
        guard let item else { return }

        do {
            if let movie = try await item.loadTransferable(type: VideoTransferable.self) {
                await MainActor.run {
                    processor.loadVideo(from: movie.url)
                }
            }
        } catch {
            await MainActor.run {
                processor.statusMessage = "Failed to load video: \(error.localizedDescription)"
            }
        }
    }
}

// MARK: - Video Transferable

struct VideoTransferable: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { video in
            SentTransferredFile(video.url)
        } importing: { received in
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(received.file.lastPathComponent)
            try? FileManager.default.removeItem(at: tempURL)
            try FileManager.default.copyItem(at: received.file, to: tempURL)
            return Self(url: tempURL)
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ContentView()
}
