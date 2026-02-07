

import Foundation
import CoreHaptics
import UIKit


enum HapticStrength: String, CaseIterable {
    case soft
    case standard
    case strong

    var intensityMultiplier: Float {
        switch self {
        case .soft: return 0.75
        case .standard: return 1.0
        case .strong: return 1.25
        }
    }
}
@MainActor
final class HapticManager {

    static let shared = HapticManager()

    private var engine: CHHapticEngine?
    private var engineRunning = false
    private var lastPlayTime: TimeInterval = 0

    var strength: HapticStrength = .standard
    
    


    private init() {
        if let saved = UserDefaults.standard.string(forKey: "hapticStrength"),
           let stored = HapticStrength(rawValue: saved) {
            strength = stored
        }
        prepareEngine()
        setupLifecycleObservers()
    }
   
    var deviceSupportsHaptics: Bool {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }


    private func prepareEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            engine?.stoppedHandler = { [weak self] _ in self?.engineRunning = false }
            engine?.resetHandler = { [weak self] in self?.startEngineIfNeeded() }
            startEngineIfNeeded()
        } catch {
            print("Haptic engine error: \(error)")
        }
    }

    private func startEngineIfNeeded() {
        guard engineRunning == false else { return }
        do {
            try engine?.start()
            engineRunning = true
        } catch {
            print("Failed to start haptic engine")
        }
    }

    private func setupLifecycleObservers() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.engine?.stop(completionHandler: nil)
            self?.engineRunning = false
        }
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.startEngineIfNeeded()
        }
    }

    private func play(events: [CHHapticEvent], curves: [CHHapticParameterCurve] = []) {
        let now = Date().timeIntervalSince1970
        guard now - lastPlayTime > 0.05 else { return }
        lastPlayTime = now
        startEngineIfNeeded()

        do {
            let pattern = try CHHapticPattern(events: events, parameterCurves: curves)
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Haptic play failed: \(error)")
        }
    }




    func primaryAction() {
        play(events: [
        
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                .init(parameterID: .hapticIntensity, value: 1.0 * strength.intensityMultiplier),
                .init(parameterID: .hapticSharpness, value: 1.0)
            ], relativeTime: 0)
        ])
    }

    func secondaryAction() {
        play(events: [
           
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                .init(parameterID: .hapticIntensity, value: 0.6 * strength.intensityMultiplier),
                .init(parameterID: .hapticSharpness, value: 0.0)
            ], relativeTime: 0)
        ])
    }

    func navigation() {
  
        play(events: [
            CHHapticEvent(eventType: .hapticContinuous, parameters: [
                .init(parameterID: .hapticIntensity, value: 0.5 * strength.intensityMultiplier),
                .init(parameterID: .hapticSharpness, value: 0.4)
            ], relativeTime: 0, duration: 0.08)
        ])
    }


    func toggleOn() {
        play(events: [
            CHHapticEvent(eventType: .hapticContinuous, parameters: [
                .init(parameterID: .hapticIntensity, value: 0.8),
                .init(parameterID: .hapticSharpness, value: 0.1)
            ], relativeTime: 0, duration: 0.25)
        ], curves: [
            CHHapticParameterCurve(parameterID: .hapticSharpnessControl, controlPoints: [
                .init(relativeTime: 0, value: 0.1),
                .init(relativeTime: 0.25, value: 1.0)
            ], relativeTime: 0)
        ])
    }

    func toggleOff() {
        play(events: [
            CHHapticEvent(eventType: .hapticContinuous, parameters: [
                .init(parameterID: .hapticIntensity, value: 0.6),
                .init(parameterID: .hapticSharpness, value: 1.0)
            ], relativeTime: 0, duration: 0.25)
        ], curves: [
            CHHapticParameterCurve(parameterID: .hapticSharpnessControl, controlPoints: [
                .init(relativeTime: 0, value: 1.0),
                .init(relativeTime: 0.25, value: 0.0)
            ], relativeTime: 0)
        ])
    }

 
    func success() {
        play(events: [
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                .init(parameterID: .hapticIntensity, value: 0.8),
                .init(parameterID: .hapticSharpness, value: 0.8)
            ], relativeTime: 0),
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                .init(parameterID: .hapticIntensity, value: 1.0),
                .init(parameterID: .hapticSharpness, value: 1.0)
            ], relativeTime: 0.1)
        ])
    }


    func error() {
        play(events: [
           
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                .init(parameterID: .hapticIntensity, value: 1.0),
                .init(parameterID: .hapticSharpness, value: 0.0)
            ], relativeTime: 0),
            
           
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                .init(parameterID: .hapticIntensity, value: 0.8),
                .init(parameterID: .hapticSharpness, value: 0.1)
            ], relativeTime: 0.2)
        ])
    }

    func warning() {
        play(events: [
            CHHapticEvent(eventType: .hapticContinuous, parameters: [
                .init(parameterID: .hapticIntensity, value: 1.0 * strength.intensityMultiplier),
                .init(parameterID: .hapticSharpness, value: 0.3)
            ], relativeTime: 0, duration: 0.6)
        ])
    }

    func selectionChange() {
        play(events: [
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                .init(parameterID: .hapticIntensity, value: 0.3),
                .init(parameterID: .hapticSharpness, value: 0.5)
            ], relativeTime: 0)
        ])
    }
}
