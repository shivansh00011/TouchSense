import SwiftUI

@main
struct MyApp: App {
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
       
            if hasSeenOnboarding {
                HomeView()
                    .transition(.move(edge: .trailing))
                    .tint(.blue)
            } else {
                OnboardingFlowView()
                    .transition(.opacity)
                    .tint(.blue)
            }
        }
    }
}
