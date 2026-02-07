import SwiftUI

struct SettingsView: View {

    @AppStorage("hapticStrength")
    private var selectedStrengthRaw: String = HapticStrength.standard.rawValue

   
    private var selectedStrength: Binding<HapticStrength> {
        Binding(
            get: { HapticStrength(rawValue: selectedStrengthRaw) ?? .standard },
            set: { newValue in
             
                selectedStrengthRaw = newValue.rawValue
                
           
                HapticManager.shared.strength = newValue
                
               
                HapticManager.shared.primaryAction()
            }
        )
    }

    var body: some View {
        Form {
          
            Section {
                HStack(spacing: 15) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.blue)
                        .frame(width: 50, height: 50)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text("Haptic Intensity")
                            .font(.headline)
                        Text("Customize how the interface feels.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

          
            Section(header: Text("Global Strength"), footer: strengthFooter) {
                Picker("Haptic Strength", selection: selectedStrength) {
                    ForEach(HapticStrength.allCases, id: \.self) { strength in
                        Text(strength.rawValue.capitalized)
                            .tag(strength)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color(uiColor: .secondarySystemGroupedBackground))
            }


            Section(header: Text("Test Current Settings")) {
                Button {
                    HapticManager.shared.success()
                } label: {
                    Label("Test Success Pattern", systemImage: "sparkles")
                        .foregroundStyle(.primary)
                }
                
                Button {
                    HapticManager.shared.error()
                } label: {
                    Label("Test Error Pattern", systemImage: "xmark.octagon")
                        .foregroundStyle(.primary)
                }
                
                Button {
                    HapticManager.shared.selectionChange()
                } label: {
                    Label("Test Grain Texture", systemImage: "circle.grid.2x2")
                        .foregroundStyle(.primary)
                }
            }

        
            Section {
                            VStack(alignment: .leading, spacing: 10) {
                                Label("Why Haptics Matter?", systemImage: "accessibility")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                
                                Text("Digital accessibility often relies heavily on audio (VoiceOver), which can be noisy and overwhelming. By moving information to touch, we reduce 'audio fatigue' and create a quieter, more intuitive experience.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.vertical, 8)
                        } footer: {
                            Text("TouchSense v1.0 • Designed for Swift Student Challenge")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top)
                        }
                    }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }


    private var strengthFooter: some View {
        Text(strengthDescription)
            .font(.caption)
            .padding(.top, 4)
    }
    
    private var strengthDescription: String {
        switch HapticStrength(rawValue: selectedStrengthRaw) ?? .standard {
        case .soft:
            return "Subtle feedback. Best for quiet environments or high-sensitivity users."
        case .standard:
            return "Balanced feedback. Recommended for most users."
        case .strong:
            return "High visibility. Best for outdoor use or users with reduced tactile sensitivity."
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
