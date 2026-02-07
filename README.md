# TouchSense 📳
> **Can touch be a language?**


![Swift 6](https://img.shields.io/badge/Swift-6.0-orange?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-iOS-blue?style=flat-square)
![Framework](https://img.shields.io/badge/Framework-Core_Haptics-green?style=flat-square)

## The Problem: Audio Fatigue
For the visually impaired, accessibility often means **noise**. Screen readers like VoiceOver are essential, but they create a constant stream of auditory information. This leads to **"Audio Fatigue"**—cognitive overload caused by listening to every single interaction.

## The Solution: Haptic Semantics
**TouchSense** shifts information from the ears to the hands. It proposes a standardized **"Tactile Vocabulary"** where distinct vibration patterns convey specific meanings without sound.

## Key Features

### 1. The Haptic Lab 
An interactive playground to feel the difference between standard vibrations and **Core Haptics** physics.
- **Primary Action:** High transient sharpness (feels like a mechanical click).
- **Secondary Action:** Low sharpness, high intensity (feels like a soft thud).
- **Toggle Switches:** Uses `CHHapticParameterCurve` to physically bend the pitch of the vibration up (ON) or down (OFF).

### 2. The Blind Test Protocol 
A "Game Mode" that removes all visual cues to test if the user can identify UI elements purely by feel.
- **Proof of Concept:** Demonstrates that haptic patterns are learnable and distinguishable.
- **Real-time Feedback:** Visualizers pulse only after the user guesses.

### 3. Adaptive Engine 
- **Hardware Safety Check:** Automatically detects if the device (e.g., iPad) lacks a Taptic Engine and degrades gracefully to visual-only feedback.
- **Intensity Customization:** Users can scale the haptic strength globally to account for phone cases or sensitivity levels.

## Tech Stack
- **Language:** Swift 6
- **UI Framework:** SwiftUI
- **Haptics:** `CoreHaptics` (CHHapticEngine, CHHapticPattern)
- **Architecture:** MVVM-inspired (Clean separation of Logic and View)
- **Format:** App Playground (`.swiftpm`)

## How to Run
This project is built as a **Swift App Playground**.

1. Download the `.zip` file from the Releases or clone this repo.
2. Open the `TouchSense.swiftpm` file in **Xcode 16+** or **Swift Playgrounds 4.6+**.
3. **Requirement:** Run on a physical **iPhone** to feel the haptics.
   - *Note:* If run on a Simulator or iPad, the app will show a "Haptics Unavailable" warning banner.

## 📸 Screenshots
<img width="200" height="1278" alt="IMG_1041" src="https://github.com/user-attachments/assets/9e6459fe-cc87-4c40-8813-77995c23cdc8" />    <img width="200" height="1278" alt="IMG_1042" src="https://github.com/user-attachments/assets/6459d870-b7e6-4c4c-b4e4-e1f2f5cd38d7" />     <img width="200" height="1278" alt="IMG_1043" src="https://github.com/user-attachments/assets/6e5999c5-3a74-44a5-a70f-0f320be982b6" />        <img width="200" height="1278" alt="IMG_1044" src="https://github.com/user-attachments/assets/1f63e6c6-1d61-4e21-ab7e-ebb7ec908ccc" />





---
*Created by Shivansh for the Swift Student Challenge.*
