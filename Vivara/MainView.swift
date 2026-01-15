import SwiftUI
import PhotosUI
import AVFoundation
import UniformTypeIdentifiers

struct MainView: View {
    @StateObject private var processor = VideoProcessor()
    @StateObject private var presetManager = PresetManager()
    @EnvironmentObject var settings: AppSettings

    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilePicker = false
    @State private var showingSettings = false
    @State private var showingProcessing = false
    @State private var showingCompletion = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.adaptiveBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Preview Card
                        previewCard

                        // Intensity Slider
                        intensityControl

                        // Presets
                        presetsSection

                        // Action Buttons
                        actionButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VivaraLogo(size: 28)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.adaptiveText)
                    }
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    await loadVideo(from: newItem)
                }
            }
            .onChange(of: presetManager.selectedPreset) { _, newPreset in
                if let preset = newPreset {
                    processor.depthThreshold = preset.intensity
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.movie, .video, .quickTimeMovie],
                allowsMultipleSelection: false
            ) { result in
                handleFileImport(result)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .fullScreenCover(isPresented: $showingProcessing) {
                ProcessingView(processor: processor) {
                    showingProcessing = false
                    if processor.outputURL != nil {
                        showingCompletion = true
                    }
                }
            }
            .fullScreenCover(isPresented: $showingCompletion) {
                if let inputURL = processor.inputURL, let outputURL = processor.outputURL {
                    CompletionView(
                        processor: processor,
                        inputURL: inputURL,
                        outputURL: outputURL
                    ) {
                        showingCompletion = false
                    }
                }
            }
        }
    }

    // MARK: - Preview Card

    private var previewCard: some View {
        VivaraPreviewCard {
            ZStack {
                // Background
                Color.adaptiveSecondaryBackground.opacity(0.5)

                if let preview = processor.previewImage ?? processor.thumbnail {
                    Image(uiImage: preview)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(16)
                        .padding(12)
                } else {
                    // Empty state
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient.brand.opacity(0.1))
                                .frame(width: 80, height: 80)

                            Image(systemName: "video.badge.plus")
                                .font(.system(size: 36))
                                .foregroundStyle(LinearGradient.brand)
                        }

                        VStack(spacing: 4) {
                            Text("Select a video")
                                .font(.headline2)
                                .foregroundColor(.adaptiveText)
                            Text("Choose from Photos or Files")
                                .font(.bodySmall)
                                .foregroundColor(.adaptiveSecondaryText)
                        }
                    }
                    .padding(40)
                }
            }
            .frame(height: 280)
        }
    }

    // MARK: - Intensity Control

    private var intensityControl: some View {
        VStack(alignment: .leading, spacing: 12) {
            VivaraSlider(
                value: $processor.depthThreshold,
                range: 0...1,
                label: "EFFECT INTENSITY"
            )
        }
        .padding(16)
        .cardStyle()
    }

    // MARK: - Presets Section

    private var presetsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("PRESETS")
                    .font(.labelSmall)
                    .foregroundColor(.adaptiveSecondaryText)
                    .tracking(1)
                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(presetManager.presets) { preset in
                        PresetButton(
                            name: preset.name,
                            icon: preset.icon,
                            isSelected: presetManager.selectedPreset?.id == preset.id
                        ) {
                            presetManager.selectPreset(preset)
                        }
                    }

                    // Add custom preset button
                    Button {
                        saveCurrentAsPreset()
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(.adaptiveSecondaryText)
                            Text("Save")
                                .font(.captionMedium)
                                .foregroundColor(.adaptiveSecondaryText)
                        }
                        .frame(width: 72, height: 72)
                        .background(Color.adaptiveSecondaryBackground)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                .foregroundColor(Color.adaptiveSecondaryText.opacity(0.5))
                        )
                    }
                }
            }
        }
        .padding(16)
        .cardStyle()
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Photos Picker
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .videos,
                    photoLibrary: .shared()
                ) {
                    HStack(spacing: 8) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Photos")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.adaptiveText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.adaptiveCard)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.adaptiveText.opacity(0.2), lineWidth: 1)
                    )
                }

                // Files Button
                Button {
                    showingFilePicker = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "folder")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Files")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.adaptiveText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.adaptiveCard)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.adaptiveText.opacity(0.2), lineWidth: 1)
                    )
                }
            }

            // Process Button
            VivaraPrimaryButton(
                "Process Video",
                icon: "wand.and.stars",
                isDisabled: processor.inputURL == nil
            ) {
                showingProcessing = true
                Task {
                    await processor.processVideo()
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func loadVideo(from item: PhotosPickerItem?) async {
        guard let item else { return }

        do {
            if let movie = try await item.loadTransferable(type: VideoTransferable.self) {
                await MainActor.run {
                    processor.loadVideo(from: movie.url)
                    presetManager.selectedPreset = nil
                }
            }
        } catch {
            await MainActor.run {
                processor.statusMessage = "Failed to load video: \(error.localizedDescription)"
            }
        }
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                guard url.startAccessingSecurityScopedResource() else { return }
                defer { url.stopAccessingSecurityScopedResource() }

                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(url.lastPathComponent)
                try? FileManager.default.removeItem(at: tempURL)
                try? FileManager.default.copyItem(at: url, to: tempURL)

                processor.loadVideo(from: tempURL)
                presetManager.selectedPreset = nil
            }
        case .failure(let error):
            processor.statusMessage = "Error: \(error.localizedDescription)"
        }
    }

    private func saveCurrentAsPreset() {
        HapticManager.impact(.medium)
        presetManager.saveCustomPreset(
            name: "Custom",
            intensity: processor.depthThreshold
        )
    }
}

// MARK: - Preview

#Preview {
    MainView()
        .environmentObject(AppSettings())
}
