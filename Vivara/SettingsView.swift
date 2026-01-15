import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.adaptiveBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Video Quality Section
                        qualitySection

                        // Processing Section
                        processingSection

                        // Appearance Section
                        appearanceSection

                        // About Section
                        aboutSection
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.electricCoral)
                }
            }
        }
    }

    // MARK: - Quality Section

    private var qualitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("VIDEO QUALITY")
                .font(.labelSmall)
                .foregroundColor(.adaptiveSecondaryText)
                .tracking(1)

            HStack(spacing: 12) {
                ForEach(ProcessingQuality.allCases) { quality in
                    QualityOptionButton(
                        quality: quality,
                        isSelected: settings.processingQuality == quality
                    ) {
                        settings.processingQuality = quality
                        HapticManager.impact(.light)
                    }
                }
            }
        }
        .padding(16)
        .cardStyle()
    }

    // MARK: - Processing Section

    private var processingSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("PROCESSING")
                .font(.labelSmall)
                .foregroundColor(.adaptiveSecondaryText)
                .tracking(1)
                .padding(.bottom, 12)

            VStack(spacing: 0) {
                SettingsRow(
                    title: "Auto-save to Photos",
                    icon: "photo.on.rectangle"
                ) {
                    Toggle("", isOn: $settings.autoSaveToPhotos)
                        .tint(.electricCoral)
                }

                Divider()
                    .padding(.leading, 44)

                SettingsRow(
                    title: "Haptic Feedback",
                    icon: "iphone.radiowaves.left.and.right"
                ) {
                    Toggle("", isOn: $settings.hapticFeedbackEnabled)
                        .tint(.electricCoral)
                }
            }
        }
        .padding(16)
        .cardStyle()
    }

    // MARK: - Appearance Section

    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("APPEARANCE")
                .font(.labelSmall)
                .foregroundColor(.adaptiveSecondaryText)
                .tracking(1)
                .padding(.bottom, 12)

            VStack(spacing: 0) {
                SettingsRow(
                    title: "Theme",
                    icon: "paintbrush"
                ) {
                    Text("System")
                        .font(.bodySmall)
                        .foregroundColor(.adaptiveSecondaryText)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.adaptiveSecondaryText)
                }
            }
        }
        .padding(16)
        .cardStyle()
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("ABOUT VIVARA")
                .font(.labelSmall)
                .foregroundColor(.adaptiveSecondaryText)
                .tracking(1)
                .padding(.bottom, 12)

            VStack(spacing: 0) {
                SettingsRow(
                    title: "Version",
                    icon: "info.circle"
                ) {
                    Text("1.0.0")
                        .font(.bodySmall)
                        .foregroundColor(.adaptiveSecondaryText)
                }

                Divider()
                    .padding(.leading, 44)

                SettingsRow(
                    title: "Privacy Policy",
                    icon: "hand.raised"
                ) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.adaptiveSecondaryText)
                }

                Divider()
                    .padding(.leading, 44)

                SettingsRow(
                    title: "Terms of Service",
                    icon: "doc.text"
                ) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.adaptiveSecondaryText)
                }

                Divider()
                    .padding(.leading, 44)

                Button {
                    requestAppReview()
                } label: {
                    SettingsRow(
                        title: "Rate Vivara",
                        icon: "star"
                    ) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.adaptiveSecondaryText)
                    }
                }
            }

            // Footer
            HStack {
                Spacer()
                Text("Made with ")
                    .font(.captionMedium)
                    .foregroundColor(.adaptiveSecondaryText)
                +
                Text("✨")
                +
                Text(" by Vivara")
                    .font(.captionMedium)
                    .foregroundColor(.adaptiveSecondaryText)
                Spacer()
            }
            .padding(.top, 24)
        }
        .padding(16)
        .cardStyle()
    }

    private func requestAppReview() {
        // TODO: Implement StoreKit review request
        HapticManager.impact(.light)
    }
}

// MARK: - Quality Option Button

struct QualityOptionButton: View {
    let quality: ProcessingQuality
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(quality.displayName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .adaptiveText)

                Text(resolutionText)
                    .font(.captionMedium)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .adaptiveSecondaryText)

                Text(speedText)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? .white.opacity(0.7) : .adaptiveSecondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Group {
                    if isSelected {
                        LinearGradient.brand
                    } else {
                        colorScheme == .dark ? Color.darkCard : Color.softGray
                    }
                }
            )
            .cornerRadius(12)
        }
    }

    private var resolutionText: String {
        switch quality {
        case .fast: return "720p"
        case .balanced: return "1080p"
        case .high: return "4K"
        }
    }

    private var speedText: String {
        switch quality {
        case .fast: return "Fast"
        case .balanced: return "Balanced"
        case .high: return "Slower"
        }
    }
}

// MARK: - Settings Row

struct SettingsRow<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let accessory: Content

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 17))
                .foregroundColor(.electricCoral)
                .frame(width: 24)

            Text(title)
                .font(.bodyRegular)
                .foregroundColor(.adaptiveText)

            Spacer()

            accessory
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environmentObject(AppSettings())
}
