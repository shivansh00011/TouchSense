import SwiftUI

struct HomeView: View {
    @State private var isEnabled = false
    @State private var feedbackText = "Touch an element to feel it."
    @State private var activeHaptic: String? = nil
    

    @State private var shakeOffset: CGFloat = 0
    @State private var alertScale: CGFloat = 1.0
    @State private var rippleScale: CGFloat = 1.0
    @State private var rippleOpacity: Double = 0.0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    if !HapticManager.shared.deviceSupportsHaptics {
                                            HStack(spacing: 12) {
                                                Image(systemName: "iphone.gen3.slash")
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text("Haptics Unavailable")
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                    Text("This device does not support Core Haptics. Run on iPhone for the full experience.")
                                                        .font(.caption)
                                                        .foregroundColor(.white.opacity(0.9))
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.orange)
                                                    .shadow(radius: 4)
                                            )
                                            .padding(.horizontal)
                                            .padding(.top, 10)
                                        }
                    
                  
                    ZStack {
                        Circle()
                            .fill(colorForHaptic(activeHaptic).opacity(0.1))
                            .frame(width: 150, height: 150)
                            .scaleEffect(rippleScale)
                            .opacity(rippleOpacity)
                        
                        VStack(spacing: 12) {
                            if #available(iOS 17.0, *) {
                                Image(systemName: iconForHaptic(activeHaptic))
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundStyle(colorForHaptic(activeHaptic))
                                    .symbolEffect(.bounce, value: activeHaptic)
                            } else {
                                Image(systemName: iconForHaptic(activeHaptic))
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundStyle(colorForHaptic(activeHaptic))
                            }
                            
                            Text(feedbackText)
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .frame(height: 200)
                    .padding(.top)

                  
                    VStack(spacing: 20) {
                        HStack(spacing: 16) {
                      
                            Button {
                                triggerHaptic(.primary, name: "Primary Click", icon: "checkmark.circle.fill")
                            } label: {
                                HapticButtonLabel(title: "Primary", icon: "checkmark", color: .blue)
                            }
                            
                          
                            Button {
                                triggerHaptic(.secondary, name: "Secondary Tap", icon: "circle.circle")
                            } label: {
                                HapticButtonLabel(title: "Secondary", icon: "circle", color: .secondary)
                            }
                        }
                        
                     
                        Toggle(isOn: $isEnabled) {
                            HStack {
                                Image(systemName: isEnabled ? "power.circle.fill" : "power.circle")
                                    .foregroundStyle(isEnabled ? .green : .gray)
                                VStack(alignment: .leading) {
                                    Text("Feature Activation")
                                        .font(.headline)
                                    Text(isEnabled ? "Rising Pitch (ON)" : "Falling Pitch (OFF)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(16)
                        .onChange(of: isEnabled) { value in
                            if value {
                                HapticManager.shared.toggleOn()
                                visualizeHaptic(name: "Toggle ON", icon: "arrow.up.right.circle.fill")
                            } else {
                                HapticManager.shared.toggleOff()
                                visualizeHaptic(name: "Toggle OFF", icon: "arrow.down.left.circle")
                            }
                        }
                        
                    
                        HStack(spacing: 16) {
                            Button {
                                triggerHaptic(.success, name: "Success", icon: "sparkles")
                            } label: {
                                HapticButtonLabel(title: "Success", icon: "sparkles", color: .green)
                            }
                            
                            Button {
                                triggerHaptic(.error, name: "Error / Block", icon: "xmark.octagon.fill")
                            } label: {
                                HapticButtonLabel(title: "Error", icon: "xmark.octagon", color: .red)
                            }
                            .offset(x: shakeOffset)
                        }
                        
                       
                        Button {
                            triggerHaptic(.warning, name: "System Alert", icon: "exclamationmark.triangle.fill")
                        } label: {
                            HapticButtonLabel(title: "Show Alert", icon: "exclamationmark.triangle", color: .orange)
                        }
                        .scaleEffect(alertScale)
                        
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationTitle("TouchSense")
            
         
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
              
                        NavigationLink(destination: GameTestView()) {
                            Image(systemName: "gamecontroller.fill")
                                .font(.system(size: 16))
                                .accessibilityLabel("Blind Test Game")
                        }
                        
               
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .accessibilityLabel("Settings")
                        }
                    }
                }
            }
        }
    }
    

    
    enum ActionType {
        case primary, secondary, success, error, warning
    }
    
    func triggerHaptic(_ type: ActionType, name: String, icon: String) {
        switch type {
        case .primary: HapticManager.shared.primaryAction()
        case .secondary: HapticManager.shared.secondaryAction()
        case .success: HapticManager.shared.success()
        case .error:
            HapticManager.shared.error()
            withAnimation(.default) { shakeOffset = 10 }
            withAnimation(.default.delay(0.1)) { shakeOffset = -10 }
            withAnimation(.default.delay(0.2)) { shakeOffset = 0 }
            
        case .warning:
            HapticManager.shared.warning()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) { alertScale = 1.1 }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.3).delay(0.1)) { alertScale = 1.0 }
        }
        
        visualizeHaptic(name: name, icon: icon)
    }
    
    func visualizeHaptic(name: String, icon: String) {
        rippleScale = 0.8
        rippleOpacity = 1.0
        activeHaptic = icon
        feedbackText = name
        withAnimation(.easeOut(duration: 0.5)) {
            rippleScale = 1.5
            rippleOpacity = 0.0
        }
    }
    
    func iconForHaptic(_ tag: String?) -> String {
        return tag ?? "hand.tap"
    }
    
    func colorForHaptic(_ tag: String?) -> Color {
        if tag == "xmark.octagon.fill" { return .red }
        if tag == "sparkles" { return .green }
        if tag == "arrow.up.right.circle.fill" { return .green }
        if tag == "exclamationmark.triangle.fill" { return .orange }
        return .accentColor
    }
}


struct HapticButtonLabel: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .padding(.bottom, 4)
            Text(title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(color.opacity(0.1))
        .foregroundStyle(color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

