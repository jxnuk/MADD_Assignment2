import SwiftUI
import CoreData
import Combine

struct StepView: View {
    let recipe: Recipe

    @State private var stepIndex = 0
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var gamification: GamificationManager

    @State private var showDoneScreen = false
    @State private var showConfetti = false

    @StateObject private var speechManager = SpeechManager()

    // Timer-related state
    @State private var countdown: Int? = nil
    @State private var timerIsRunning = false
    @State private var timerFinished = false
    @State private var targetEndTime: Date? = nil
    @State private var usedTimerThisRecipe = false
    @State private var perfectTimerForRecipe = false

    private let tickTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var currentStep: RecipeStep {
        recipe.steps[stepIndex]
    }

    var progress: Double {
        guard !recipe.steps.isEmpty else { return 0 }
        return Double(stepIndex + 1) / Double(recipe.steps.count)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.1, green: 0.08, blue: 0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                if showDoneScreen {
                    doneView
                } else {
                    stepsView
                }
            }
            .padding(.horizontal, 60)
            .padding(.top, 40)
            .navigationTitle(recipe.name)

            if showDoneScreen && showConfetti {
                ConfettiView()
            }
        }
        .onAppear {
            speakCurrentStep(isFirst: true)
        }
        .onDisappear {
            speechManager.stop()
        }
        .onReceive(tickTimer) { _ in
            handleTick()
        }
    }

    private var stepsView: some View {
        VStack(spacing: 36) {
            Text("Step \(stepIndex + 1) of \(recipe.steps.count)")
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(.white)

            // Progress bar card
            VStack(spacing: 14) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 18)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.98, green: 0.6, blue: 0.24),
                                             Color(red: 0.9, green: 0.25, blue: 0.46)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * progress, height: 18)
                            .animation(.easeInOut(duration: 0.3), value: progress)
                    }
                }
                .frame(height: 24)

                Text("\(Int(progress * 100))% completed")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .frame(width: 700)

            // Step text card
            VStack(spacing: 14) {
                Text(currentStep.text)
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                if let duration = currentStep.duration {
                    timerControls(duration: duration)
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 32)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.6), radius: 20, x: 0, y: 12)
            .frame(maxWidth: 900)

            // Navigation buttons
            HStack(spacing: 60) {
                Button("Previous") {
                    if stepIndex > 0 {
                        stepIndex -= 1
                        resetTimer()
                        speakCurrentStep()
                    }
                }
                .font(.title3)
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.12))
                )
                .buttonStyle(.plain)

                Button(stepIndex == recipe.steps.count - 1 ? "Finish" : "Next") {
                    handleNext()
                }
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 40)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.99, green: 0.58, blue: 0.22),
                                 Color(red: 0.94, green: 0.25, blue: 0.42)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(26)
                .shadow(color: .black.opacity(0.7), radius: 22, x: 0, y: 14)
                .buttonStyle(.plain)
            }

            Spacer()
        }
    }

    private func timerControls(duration: Int) -> some View {
        VStack(spacing: 12) {
            Text("Suggested timer: \(duration / 60) min \(duration % 60) sec")
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))

            if timerIsRunning || timerFinished, let remaining = countdown {
                Text(remaining > 0 ? "Time left: \(remaining) sec" : "Time is up!")
                    .font(.title3.bold())
                    .foregroundColor(remaining > 0 ? .yellow : .green)
            }

            HStack(spacing: 30) {
                if !timerIsRunning && !timerFinished {
                    Button("Start Timer") {
                        startTimer(duration: duration)
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 26)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.16))
                    )
                    .buttonStyle(.plain)
                } else if timerIsRunning {
                    Button("Cancel Timer") {
                        resetTimer()
                    }
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 26)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.red.opacity(0.4))
                    )
                    .buttonStyle(.plain)
                } else if timerFinished {
                    Button("Reset Timer") {
                        resetTimer()
                    }
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 26)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.16))
                    )
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.top, 10)
    }

    private var doneView: some View {
        VStack(spacing: 34) {
            Text("🎉 You're Done! 🎉")
                .font(.system(size: 72, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 14)

            Text("You have completed \(recipe.name).")
                .font(.title2)
                .foregroundColor(.white.opacity(0.9))

            HStack(spacing: 40) {
                Button("Restart Recipe") {
                    stepIndex = 0
                    showDoneScreen = false
                    showConfetti = false
                    resetTimer()
                    usedTimerThisRecipe = false
                    perfectTimerForRecipe = false
                    speakCurrentStep(isFirst: true)
                }
                .font(.title3)
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color.white.opacity(0.16))
                )
                .buttonStyle(.plain)

                Button("Return to Home") {
                    goBackToHome()
                }
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 40)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.98, green: 0.53, blue: 0.24),
                                 Color(red: 0.9, green: 0.22, blue: 0.39)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(26)
                .shadow(color: .black.opacity(0.7), radius: 22, x: 0, y: 14)
                .buttonStyle(.plain)
            }

            Spacer()
        }
        .onAppear {
            showConfetti = true
            speechManager.speak("Congratulations! You have finished the recipe.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                goBackToHome()
            }
        }
    }

    // MARK: - Logic (unchanged)

    private func handleNext() {
        var perfectThisStep = false
        if let end = targetEndTime, timerFinished {
            let diff = Date().timeIntervalSince(end)
            if diff >= 0 && diff <= 3 {
                perfectThisStep = true
                perfectTimerForRecipe = true
            }
        }

        resetTimer()

        if stepIndex < recipe.steps.count - 1 {
            stepIndex += 1
            speakCurrentStep()
        } else {
            completeRecipe()
        }

        if perfectThisStep {
            print("Perfect timer on this step!")
        }
    }

    private func handleTick() {
        guard timerIsRunning, let end = targetEndTime else { return }
        let remaining = Int(end.timeIntervalSinceNow.rounded())
        if remaining <= 0 {
            countdown = 0
            timerIsRunning = false
            timerFinished = true
        } else {
            countdown = remaining
        }
    }

    private func startTimer(duration: Int) {
        targetEndTime = Date().addingTimeInterval(TimeInterval(duration))
        countdown = duration
        timerIsRunning = true
        timerFinished = false
        usedTimerThisRecipe = true
    }

    private func resetTimer() {
        countdown = nil
        timerIsRunning = false
        timerFinished = false
        targetEndTime = nil
    }

    private func speakCurrentStep(isFirst: Bool = false) {
        let prefix = isFirst ? "Let's start cooking. " : "Next step. "
        let text = prefix + currentStep.text
        speechManager.speak(text)
    }

    private func completeRecipe() {
        saveCompletedRecipe()
        gamification.notifyRecipeCompleted(
            recipe: recipe,
            usedTimer: usedTimerThisRecipe,
            perfectTimer: perfectTimerForRecipe
        )
        showDoneScreen = true
    }

    private func saveCompletedRecipe() {
        let fetchRequest: NSFetchRequest<CompletedRecipe> = CompletedRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id)

        do {
            let results = try context.fetch(fetchRequest)
            if let existing = results.first {
                existing.timesCompleted += 1
                existing.completedAt = Date()
            } else {
                let newCompleted = CompletedRecipe(context: context)
                newCompleted.id = recipe.id
                newCompleted.name = recipe.name
                newCompleted.completedAt = Date()
                newCompleted.timesCompleted = 1
            }
            try context.save()
        } catch {
            print("Error saving completed recipe: \(error)")
        }
    }

    private func goBackToHome() {
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismiss()
        }
    }
}
