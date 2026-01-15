import SwiftUI
import UIKit

// MARK: - Brand Colors

extension Color {
    // Primary Brand Colors
    static let electricCoral = Color(hex: "#FF6B6B")
    static let vividPurple = Color(hex: "#845EF7")
    static let luminousCyan = Color(hex: "#22D3EE")

    // Neutral Colors (fixed, not adaptive)
    static let charcoalGray = Color(hex: "#374151")
    static let softGray = Color(hex: "#F3F4F6")
    static let mediumGray = Color(hex: "#9CA3AF")

    // Dark Mode Variants (fixed, not adaptive)
    static let darkBackground = Color(hex: "#1F2937")
    static let darkCard = Color(hex: "#374151")
    static let lightText = Color(hex: "#F9FAFB")

    // Adaptive Colors - automatically switch based on color scheme
    static let adaptiveBackground = Color(light: Color(hex: "#F3F4F6"), dark: Color(hex: "#1F2937"))
    static let adaptiveCard = Color(light: .white, dark: Color(hex: "#374151"))
    static let adaptiveText = Color(light: Color(hex: "#374151"), dark: Color(hex: "#F9FAFB"))
    static let adaptiveSecondaryText = Color(light: Color(hex: "#9CA3AF"), dark: Color(hex: "#9CA3AF"))
    static let adaptiveSecondaryBackground = Color(light: Color(hex: "#F3F4F6"), dark: Color(hex: "#2D3748"))

    // Brighter variants for dark mode logo
    static let electricCoralBright = Color(hex: "#FF8787")
    static let vividPurpleBright = Color(hex: "#9B7AFF")

    // Hex initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // Light/Dark mode initializer
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}

// MARK: - Brand Gradients

extension LinearGradient {
    /// Primary brand gradient: Electric Coral to Vivid Purple
    static let brand = LinearGradient(
        colors: [.electricCoral, .vividPurple],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Full aura gradient: Coral to Purple to Cyan
    static let aura = LinearGradient(
        colors: [.electricCoral, .vividPurple, .luminousCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Vertical brand gradient
    static let brandVertical = LinearGradient(
        colors: [.electricCoral, .vividPurple],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Subtle background gradient
    static let subtleBackground = LinearGradient(
        colors: [Color.adaptiveSecondaryBackground, Color.adaptiveCard],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Typography

extension Font {
    // Display
    static let displayLarge = Font.system(size: 48, weight: .bold)
    static let displayMedium = Font.system(size: 36, weight: .bold)

    // Headlines
    static let headline1 = Font.system(size: 32, weight: .bold)
    static let headline2 = Font.system(size: 28, weight: .semibold)
    static let headline3 = Font.system(size: 24, weight: .semibold)

    // Body
    static let bodyLarge = Font.system(size: 18, weight: .regular)
    static let bodyRegular = Font.system(size: 16, weight: .regular)
    static let bodySmall = Font.system(size: 14, weight: .regular)

    // Caption & Label
    static let captionMedium = Font.system(size: 12, weight: .medium)
    static let labelSmall = Font.system(size: 11, weight: .medium)
}

// MARK: - Haptic Feedback

struct HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - Primary Button

struct VivaraPrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isDisabled: Bool = false

    init(_ title: String, icon: String? = nil, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button {
            HapticManager.impact(.medium)
            action()
        } label: {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Group {
                    if isDisabled {
                        Color.mediumGray
                    } else {
                        LinearGradient.brand
                    }
                }
            )
            .cornerRadius(12)
            .shadow(
                color: isDisabled ? .clear : .electricCoral.opacity(0.3),
                radius: 12,
                y: 4
            )
        }
        .disabled(isDisabled)
    }
}

// MARK: - Secondary Button

struct VivaraSecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button {
            HapticManager.impact(.light)
            action()
        } label: {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundColor(.adaptiveText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.adaptiveText, lineWidth: 2)
            )
            .cornerRadius(12)
        }
    }
}

// MARK: - Preview Card

struct VivaraPreviewCard<Content: View>: View {
    let content: Content
    @Environment(\.colorScheme) var colorScheme

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(Color.adaptiveCard)
            .cornerRadius(24)
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 12, y: 4)
    }
}

// MARK: - Gradient Progress Bar

struct VivaraProgressBar: View {
    let progress: Double
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorScheme == .dark ? Color.darkCard : Color.softGray)

                // Filled portion with gradient
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient.brand)
                    .frame(width: max(0, geometry.size.width * progress))
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 8)
    }
}

// MARK: - Gradient Slider

struct VivaraSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let label: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.bodySmall)
                    .foregroundColor(.adaptiveText)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.captionMedium)
                    .foregroundColor(.adaptiveSecondaryText)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colorScheme == .dark ? Color.darkCard : Color.softGray)

                    // Filled portion with gradient
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient.brand)
                        .frame(width: max(0, geometry.size.width * normalizedValue))

                    // Thumb
                    Circle()
                        .fill(colorScheme == .dark ? Color.lightText : Color.white)
                        .frame(width: 24, height: 24)
                        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
                        .offset(x: max(0, min(geometry.size.width - 24, (geometry.size.width - 24) * normalizedValue)))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    let newValue = gesture.location.x / geometry.size.width
                                    value = range.lowerBound + (range.upperBound - range.lowerBound) * max(0, min(1, newValue))
                                    HapticManager.selection()
                                }
                        )
                }
            }
            .frame(height: 24)
        }
    }

    private var normalizedValue: Double {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
}

// MARK: - Logo View

struct VivaraLogo: View {
    var size: CGFloat = 48
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 0) {
            // "Viv" in gradient
            Text("Viv")
                .font(.system(size: size, weight: .bold, design: .default))
                .foregroundStyle(LinearGradient.brand)

            // "ara" in charcoal/light gray
            Text("ara")
                .font(.system(size: size, weight: .medium, design: .default))
                .foregroundColor(colorScheme == .dark ? .lightText : .charcoalGray)
        }
    }
}

// MARK: - Card Style Modifier

struct CardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(colorScheme == .dark ? Color.darkCard : Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 8, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// MARK: - Preset Button

struct PresetButton: View {
    let name: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button {
            HapticManager.impact(.light)
            action()
        } label: {
            VStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 24))
                Text(name)
                    .font(.captionMedium)
                    .foregroundColor(isSelected ? .white : .adaptiveText)
            }
            .frame(width: 72, height: 72)
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
}

// MARK: - Share Button

struct ShareOptionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button {
            HapticManager.impact(.light)
            action()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.electricCoral)
                Text(title)
                    .font(.captionMedium)
                    .foregroundColor(.adaptiveText)
            }
            .frame(width: 72, height: 72)
            .background(colorScheme == .dark ? Color.darkCard : Color.softGray)
            .cornerRadius(12)
        }
    }
}

// MARK: - Animated Gradient Border

struct GradientBorder: ViewModifier {
    let lineWidth: CGFloat
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(LinearGradient.brand, lineWidth: lineWidth)
            )
    }
}

extension View {
    func gradientBorder(lineWidth: CGFloat = 2, cornerRadius: CGFloat = 16) -> some View {
        modifier(GradientBorder(lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
}

// MARK: - Glow Effect

struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.6), radius: radius / 2)
            .shadow(color: color.opacity(0.4), radius: radius)
            .shadow(color: color.opacity(0.2), radius: radius * 1.5)
    }
}

extension View {
    func glow(color: Color = .electricCoral, radius: CGFloat = 10) -> some View {
        modifier(GlowEffect(color: color, radius: radius))
    }
}

// MARK: - Pulsing Animation

struct PulsingAnimation: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .opacity(isPulsing ? 0.9 : 1.0)
            .animation(
                .easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

extension View {
    func pulsing() -> some View {
        modifier(PulsingAnimation())
    }
}

// MARK: - Loading Dots

struct LoadingDots: View {
    @State private var animationPhase = 0

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(LinearGradient.brand)
                    .frame(width: 10, height: 10)
                    .scaleEffect(animationPhase == index ? 1.3 : 1.0)
                    .opacity(animationPhase == index ? 1.0 : 0.5)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    animationPhase = (animationPhase + 1) % 3
                }
            }
        }
    }
}

// MARK: - Processing Tips

struct ProcessingTip {
    static let tips = [
        "Higher quality takes longer but produces stunning results",
        "Keep your device unlocked for faster processing",
        "Videos with clear person visibility work best",
        "Try adjusting the intensity slider for different effects",
        "Share your creations directly to Instagram or TikTok"
    ]

    static func random() -> String {
        tips.randomElement() ?? tips[0]
    }
}

// MARK: - Preview

#Preview("Design System") {
    ScrollView {
        VStack(spacing: 24) {
            VivaraLogo(size: 48)

            VivaraPrimaryButton("Process Video", icon: "wand.and.stars") {
                print("Primary tapped")
            }

            VivaraPrimaryButton("Disabled", icon: "xmark", isDisabled: true) {
                print("Disabled tapped")
            }

            VivaraSecondaryButton("Choose from Photos", icon: "photo.on.rectangle") {
                print("Secondary tapped")
            }

            VivaraProgressBar(progress: 0.67)
                .frame(height: 8)

            HStack(spacing: 12) {
                PresetButton(name: "Cinema", icon: "🎬", isSelected: true) {}
                PresetButton(name: "Subtle", icon: "✨", isSelected: false) {}
                PresetButton(name: "Dreamy", icon: "🌙", isSelected: false) {}
            }

            HStack(spacing: 12) {
                ShareOptionButton(title: "Save", icon: "square.and.arrow.down") {}
                ShareOptionButton(title: "Share", icon: "square.and.arrow.up") {}
                ShareOptionButton(title: "Compare", icon: "rectangle.on.rectangle") {}
            }

            LoadingDots()

            Text("Your color. Your moment.")
                .font(.headline2)
                .foregroundStyle(LinearGradient.brand)
        }
        .padding()
    }
    .background(Color.adaptiveBackground)
}
