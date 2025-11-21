import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var gamification: GamificationManager

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.black, Color(red: 0.1, green: 0.08, blue: 0.18)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                // Title
                Text("🏆 Achievements")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)

                // Rank + XP summary
                Text("Rank: \(gamification.currentRank.displayName) • XP: \(gamification.totalXP)")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.85))

                if let xpToNext = gamification.xpToNextRank {
                    Text("\(xpToNext) XP until next rank")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                } else {
                    Text("You reached the top rank!")
                        .font(.subheadline)
                        .foregroundColor(.green.opacity(0.8))
                }

                // Achievements grid
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 24),
                            GridItem(.flexible(), spacing: 24)
                        ],
                        spacing: 24
                    ) {
                        ForEach(gamification.allAchievements) { achievement in
                            AchievementCard(
                                achievement: achievement,
                                unlocked: gamification.unlockedAchievementIDs.contains(achievement.id)
                            )
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                }

                Spacer()
            }
            .padding(.top, 30)
        }
        .navigationTitle("Achievements")
    }
}

private struct AchievementCard: View {
    let achievement: Achievement
    let unlocked: Bool
    @State private var isFocused: Bool = false

    var body: some View {
        VStack(spacing: 12) {

            // Icon
            Text(achievement.icon)
                .font(.system(size: 52))
                .shadow(radius: unlocked ? 10 : 0)

            // Name
            Text(achievement.name)
                .font(.headline)
                .foregroundColor(.white)

            // Description
            Text(achievement.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.78))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(20)
        .frame(width: 380, height: 170)

        // Background fix (no ternary — now uses Group)
        .background(
            Group {
                if unlocked {
                    LinearGradient(
                        colors: [
                            Color(red: 0.27, green: 0.55, blue: 0.33),
                            Color(red: 0.17, green: 0.3, blue: 0.19)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    Color.white.opacity(0.04)
                }
            }
        )

        // Card outline
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    unlocked ? Color.white.opacity(0.7) : Color.white.opacity(0.1),
                    lineWidth: unlocked ? 2 : 1
                )
        )

        // Unlocked/Locked badge
        .overlay(alignment: .topLeading) {
            if unlocked {
                Text("Unlocked")
                    .font(.caption2)
                    .padding(6)
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(8)
                    .padding(8)
            } else {
                Text("Locked")
                    .font(.caption2)
                    .padding(6)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                    .padding(8)
                    .opacity(0.8)
            }
        }

        // Style differences
        .opacity(unlocked ? 1.0 : 0.65)
        .scaleEffect(isFocused ? 1.04 : 1.0)
        .shadow(
            color: .black.opacity(isFocused ? 0.7 : 0.3),
            radius: isFocused ? 18 : 10,
            x: 0,
            y: isFocused ? 14 : 6
        )
        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isFocused)

        // Focus animation for tvOS
        .focusable(true) { focus in
            isFocused = focus
        }
    }
}
