import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var settings: AppSettings
    let onComplete: () -> Void

    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "YOU RADIATE",
            subtitle: "in vivid, stunning color",
            description: "AI-powered person segmentation isolates you from the world",
            illustration: "person.fill",
            gradientColors: [.electricCoral, .vividPurple]
        ),
        OnboardingPage(
            title: "ONE-TAP MAGIC",
            subtitle: "Professional results in seconds",
            description: "No editing skills needed. Just select, tap, and share",
            illustration: "wand.and.stars",
            gradientColors: [.vividPurple, .luminousCyan]
        ),
        OnboardingPage(
            title: "SHARE EVERYWHERE",
            subtitle: "Ready for your favorite platforms",
            description: "Perfect for Instagram, TikTok, YouTube and beyond",
            illustration: "square.and.arrow.up",
            gradientColors: [.luminousCyan, .electricCoral]
        )
    ]

    var body: some View {
        ZStack {
            // Background
            Color.adaptiveBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        completeOnboarding()
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.adaptiveSecondaryText)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.electricCoral : Color.mediumGray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 32)

                // Action button
                VivaraPrimaryButton(
                    currentPage == pages.count - 1 ? "Get Started" : "Continue",
                    icon: currentPage == pages.count - 1 ? "sparkles" : "arrow.right"
                ) {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        completeOnboarding()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }

    private func completeOnboarding() {
        HapticManager.notification(.success)
        settings.hasSeenOnboarding = true
        onComplete()
    }
}

// MARK: - Onboarding Page Model

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let illustration: String
    let gradientColors: [Color]
}

// MARK: - Onboarding Page View

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Illustration
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: page.gradientColors.map { $0.opacity(0.3) } + [.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)

                // Icon circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: page.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .shadow(color: page.gradientColors[0].opacity(0.4), radius: 20, y: 10)

                // Icon
                Image(systemName: page.illustration)
                    .font(.system(size: 56, weight: .medium))
                    .foregroundColor(.white)
            }

            // Text content
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text(page.title)
                        .font(.headline1)
                        .foregroundStyle(
                            LinearGradient(
                                colors: page.gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text(page.subtitle)
                        .font(.headline3)
                        .foregroundColor(.adaptiveText)
                }

                Text(page.description)
                    .font(.bodyRegular)
                    .foregroundColor(.adaptiveSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView {
        print("Onboarding complete")
    }
    .environmentObject(AppSettings())
}
