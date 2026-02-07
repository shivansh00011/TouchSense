import SwiftUI

struct GameTestView: View {
    @State private var currentRound = 1
    @State private var score = 0
    @State private var isGameActive = false
    @State private var targetHaptic: String = ""
    @State private var showFeedback = false
    @State private var feedbackMessage = ""
    @State private var feedbackColor = Color.clear

   
    let challenges = [
        ("checkmark", "Primary Click", HapticManager.shared.primaryAction),
        ("circle", "Secondary Tap", HapticManager.shared.secondaryAction),
        ("exclamationmark.triangle", "Warning", HapticManager.shared.warning),
        ("sparkles", "Success", HapticManager.shared.success),
        ("xmark.octagon", "Error", HapticManager.shared.error)
    ]

    var body: some View {
        VStack(spacing: 30) {
          
            HStack {
                Text("Blind Test")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Text("Score: \(score)/5")
                    .font(.headline)
                    .monospacedDigit()
            }
            .padding()

            Spacer()

            if isGameActive {
             
                VStack(spacing: 40) {
                  
                    Button(action: replayHaptic) {
                        ZStack {
                            Circle()
                                .fill(Color.accentColor.opacity(0.1))
                                .frame(width: 200, height: 200)
                            
                            VStack {
                                Image(systemName: "hand.tap.fill")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.primary)
                                Text("Tap to Feel")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    Text("What did you feel?")
                        .font(.title2)
                        .fontWeight(.medium)

                
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(challenges, id: \.0) { challenge in
                            Button {
                                checkAnswer(selected: challenge.1)
                            } label: {
                                Text(challenge.1)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .transition(.opacity)
                
            } else {
           
                VStack(spacing: 20) {
                    Image(systemName: "eye.slash.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.secondary)
                    
                    Text("Close Your Eyes")
                        .font(.title)
                        .bold()
                    
                    Text("Can you identify the UI element purely by touch? Test your mastery of the haptic language.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    Button("Start Challenge") {
                        startGame()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.top)
                }
            }

            Spacer()
        }
        .overlay {
          
            if showFeedback {
                Color.black.opacity(0.4).ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: feedbackMessage == "Correct!" ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(feedbackColor)
                    Text(feedbackMessage)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.white)
                }
                .transition(.scale)
            }
        }
    }



    func startGame() {
        score = 0
        currentRound = 1
        withAnimation { isGameActive = true }
        prepareRound()
    }

    func prepareRound() {
       
        if let randomChallenge = challenges.randomElement() {
            targetHaptic = randomChallenge.1
 
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                randomChallenge.2()
            }
        }
    }

    func replayHaptic() {
        
        if let challenge = challenges.first(where: { $0.1 == targetHaptic }) {
            challenge.2()
        }
    }

    func checkAnswer(selected: String) {
        let isCorrect = selected == targetHaptic
        
        if isCorrect {
            score += 1
            feedbackMessage = "Correct!"
            feedbackColor = .green
            HapticManager.shared.success()
        } else {
            feedbackMessage = "Wrong!"
            feedbackColor = .red
            HapticManager.shared.error()
        }

        withAnimation { showFeedback = true }

        // Hide feedback and Next Round
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showFeedback = false }
            if currentRound < 5 {
                currentRound += 1
                prepareRound()
            } else {
                // Game Over (Reset)
                withAnimation { isGameActive = false }
            }
        }
    }
}

