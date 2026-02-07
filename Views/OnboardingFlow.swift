import SwiftUI



struct OnboardingFlowView: View {
    @State private var currentPage = 0
   
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some View {
        ZStack {
           
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // TabView for the pages
                TabView(selection: $currentPage) {
                    WelcomePageView()
                        .tag(0)
                    HapticLanguagePageView()
                        .tag(1)
                    FinalCallToActionView(onFinish: finishOnboarding)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)

              
                VStack(spacing: 20) {
       
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(currentPage == index ? Color.accentColor : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    .padding(.top, 10)

             
                    Button(action: advancePage) {
                        Text(currentPage == 2 ? "Start Demo" : "Continue")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.accentColor)
                                    .shadow(color: Color.accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
        }
    }

   
    private func advancePage() {
        if currentPage < 2 {
            withAnimation {
                currentPage += 1
            }
        } else {
            finishOnboarding()
        }
    }
    
   
    private func finishOnboarding() {
        withAnimation {
          
            hasSeenOnboarding = true
        }
    }
}


struct WelcomePageView: View {
    var body: some View {
        OnboardingPage(
            title: "Welcome to\nTouchSense",
            description: "A new way to experience your world. We're moving beyond just sight and sound to let you feel the interface.",
            visualContent: {
             
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: [Color.accentColor.opacity(0.1), Color.purple.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 220)
                    
                    HStack(spacing: 20) {
                        SenseIcon(icon: "eye.fill", label: "Sight", color: .blue)
                        
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundColor(.gray.opacity(0.5))
                        
                   
                        VStack(spacing: 12) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.purple)
                                .padding(15)
                                .background(Color.purple.opacity(0.15))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                                )
                            Text("Touch")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.gray.opacity(0.5))

                        SenseIcon(icon: "ear.fill", label: "Haptic", color: .orange)
                    }
                }
            }
        )
    }
}

struct SenseIcon: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 35))
                .foregroundColor(color.opacity(0.7))
                .padding(10)
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}



struct HapticLanguagePageView: View {
    var body: some View {
        OnboardingPage(
            title: "A Language for Your Fingers",
            description: "Just like icons for your eyes, each action has a unique 'haptic signature'.",
            visualContent: {
                VStack(spacing: 14) {
                    HapticCard(
                        title: "Button Click",
                        description: "Light, single tap.",
                        icon: "rectangle.portrait.fill",
                        color: .green
                    ) {
                      
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.green)
                            .frame(width: 4, height: 30)
                    }

                    HapticCard(
                        title: "Warning",
                        description: "Distinct, notifying pulse.",
                        icon: "exclamationmark.triangle.fill",
                        color: .orange
                    ) {
                        
                        HStack(spacing: 4) {
                            ForEach(0..<3) { _ in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.orange)
                                    .frame(width: 4, height: 25)
                            }
                        }
                    }

                    HapticCard(
                        title: "Navigation",
                        description: "Gentle, directional flow.",
                        icon: "location.fill",
                        color: .blue
                    ) {
                       
                        HapticWaveView(color: .blue, waves: 3)
                            .frame(height: 30)
                    }
                }
                .padding(.horizontal, 10)
            }
        )
    }
}



struct FinalCallToActionView: View {
    var onFinish: () -> Void
    
    var body: some View {
        OnboardingPage(
            title: "Ready to Feel\nthe Difference?",
            description: "Tap on below button to start the interactive demo and learn the haptic language.",
            visualContent: {
                ZStack {
                 
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(Color.accentColor.opacity(0.2 - (Double(index) * 0.05)), lineWidth: 1)
                            .frame(width: 180 + CGFloat(index * 40), height: 180 + CGFloat(index * 40))
                    }

                
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.accentColor)
                        .background(
                            Circle()
                                .fill(Color.accentColor.opacity(0.1))
                                .frame(width: 120, height: 120)
                        )
                }
                .padding(.vertical, 20)
            }
        )
    }
}



struct OnboardingPage<VisualContent: View>: View {
    let title: String
    let description: String
    @ViewBuilder let visualContent: VisualContent
    
    var body: some View {
     
        VStack(spacing: 20) {
            Spacer()
            
            Text(title)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 20)
            
            Spacer()
            
            visualContent
                .frame(maxWidth: .infinity)
            
            Spacer()
            Spacer()
        }
        .padding(24)
    }
}


struct HapticCard<HapticVisual: View>: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    @ViewBuilder let hapticVisual: HapticVisual
    
    var body: some View {
        HStack(spacing: 12) {
          
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(color.gradient)
                .cornerRadius(10)
            
         
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
       
            hapticVisual
                .frame(width: 50)
                .padding(.trailing, 4)
        }
        .padding(12)
       
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


struct HapticWaveView: View {
    var color: Color = .accentColor
    var waves: Int = 4
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<waves, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color.opacity(Double(waves - index) / Double(waves)))
                    .frame(width: 4, height: 15 + CGFloat(index * 4))
            }
        }
    }
}


#Preview {
    OnboardingFlowView()
}
