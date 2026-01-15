import SwiftUI

struct SplashView: View {
    @State private var logoOpacity: Double = 0
    @State private var logoScale: Double = 0.8
    @State private var taglineOpacity: Double = 0
    @State private var glowRadius: Double = 0
    @State private var showLoadingDots = false

    let onComplete: () -> Void

    var body: some View {
        ZStack {
            // Background
            Color.adaptiveBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Logo with glow effect
                ZStack {
                    // Glow behind logo
                    VivaraLogo(size: 56)
                        .blur(radius: glowRadius)
                        .opacity(glowRadius > 0 ? 0.6 : 0)

                    // Main logo
                    VivaraLogo(size: 56)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                // Tagline
                Text("Your color. Your moment.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.adaptiveText)
                    .opacity(taglineOpacity)

                Spacer()

                // Loading indicator
                if showLoadingDots {
                    LoadingDots()
                        .transition(.opacity)
                }

                Spacer()
                    .frame(height: 60)
            }
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Logo fade in and scale
        withAnimation(.easeOut(duration: 0.8)) {
            logoOpacity = 1
            logoScale = 1
        }

        // Glow pulse
        withAnimation(.easeInOut(duration: 1.2).delay(0.3)) {
            glowRadius = 20
        }

        // Tagline fade in
        withAnimation(.easeOut(duration: 0.6).delay(0.5)) {
            taglineOpacity = 1
        }

        // Show loading dots
        withAnimation(.easeOut(duration: 0.3).delay(0.8)) {
            showLoadingDots = true
        }

        // Complete after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                onComplete()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SplashView {
        print("Splash complete")
    }
}
