import SwiftUI

// MARK: - Effect Preset Model

struct EffectPreset: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let intensity: Double
    let icon: String
    let isCustom: Bool

    static let defaults: [EffectPreset] = [
        EffectPreset(id: UUID(), name: "Cinema", intensity: 0.85, icon: "🎬", isCustom: false),
        EffectPreset(id: UUID(), name: "Subtle", intensity: 0.5, icon: "✨", isCustom: false),
        EffectPreset(id: UUID(), name: "Dreamy", intensity: 0.7, icon: "🌙", isCustom: false),
        EffectPreset(id: UUID(), name: "Bold", intensity: 1.0, icon: "🔥", isCustom: false),
    ]
}

// MARK: - Preset Manager

@MainActor
class PresetManager: ObservableObject {
    @Published var presets: [EffectPreset] = EffectPreset.defaults
    @Published var selectedPreset: EffectPreset?

    private let storageKey = "vivara_custom_presets"

    init() {
        loadCustomPresets()
    }

    func selectPreset(_ preset: EffectPreset) {
        selectedPreset = preset
        HapticManager.impact(.light)
    }

    func saveCustomPreset(name: String, intensity: Double) {
        let preset = EffectPreset(
            id: UUID(),
            name: name,
            intensity: intensity,
            icon: "💫",
            isCustom: true
        )
        presets.append(preset)
        saveCustomPresets()
        HapticManager.notification(.success)
    }

    func deleteCustomPreset(_ preset: EffectPreset) {
        guard preset.isCustom else { return }
        presets.removeAll { $0.id == preset.id }
        saveCustomPresets()
    }

    private func saveCustomPresets() {
        let customPresets = presets.filter { $0.isCustom }
        if let data = try? JSONEncoder().encode(customPresets) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadCustomPresets() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let customPresets = try? JSONDecoder().decode([EffectPreset].self, from: data) else {
            return
        }
        presets = EffectPreset.defaults + customPresets
    }
}

// MARK: - Processing Quality

enum ProcessingQuality: String, CaseIterable, Identifiable {
    case fast = "Fast"
    case balanced = "Balanced"
    case high = "High"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var description: String {
        switch self {
        case .fast: return "720p · Quick processing"
        case .balanced: return "1080p · Best quality/speed"
        case .high: return "4K · Maximum quality"
        }
    }

    var resolution: CGSize {
        switch self {
        case .fast: return CGSize(width: 1280, height: 720)
        case .balanced: return CGSize(width: 1920, height: 1080)
        case .high: return CGSize(width: 3840, height: 2160)
        }
    }
}

// MARK: - App Settings

class AppSettings: ObservableObject {
    @AppStorage("processing_quality_raw") private var processingQualityRaw: String = ProcessingQuality.balanced.rawValue
    @AppStorage("auto_save_to_photos") var autoSaveToPhotos: Bool = false
    @AppStorage("haptic_feedback_enabled") var hapticFeedbackEnabled: Bool = true
    @AppStorage("has_seen_onboarding") var hasSeenOnboarding: Bool = false

    var processingQuality: ProcessingQuality {
        get { ProcessingQuality(rawValue: processingQualityRaw) ?? .balanced }
        set { processingQualityRaw = newValue.rawValue }
    }
}
