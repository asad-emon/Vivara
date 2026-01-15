import SwiftUI

@main
struct VivaraApp: App {
    @StateObject private var settings = AppSettings()
    @State private var appState: AppState = .splash

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch appState {
                case .splash:
                    SplashView {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if settings.hasSeenOnboarding {
                                appState = .main
                            } else {
                                appState = .onboarding
                            }
                        }
                    }
                    .transition(.opacity)

                case .onboarding:
                    OnboardingView {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            appState = .main
                        }
                    }
                    .environmentObject(settings)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))

                case .main:
                    MainView()
                        .environmentObject(settings)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                }
            }
        }
    }
}

// MARK: - App State

enum AppState {
    case splash
    case onboarding
    case main
}
