import SwiftUI
import CoreData
import Combine

struct HomeView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CompletedRecipe.completedAt, ascending: false)]
    ) private var completedRecipes: FetchedResults<CompletedRecipe>

    @EnvironmentObject var gamification: GamificationManager

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.black, Color(red: 0.08, green: 0.08, blue: 0.12), Color(red: 0.16, green: 0.11, blue: 0.28)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    // App title
                    VStack(spacing: 8) {
                        Text("🍳 CookAlong TV")
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 10)

                        Text("Gamified Cooking Experience")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 40)

                    // Rank + XP card
                    VStack(spacing: 16) {
                        Text("Chef Profile")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white.opacity(0.9))

                        Text(gamification.currentRank.displayName)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)

                        Text("Total XP: \(gamification.totalXP)")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))

                        if let xpToNext = gamification.xpToNextRank {
                            Text("\(xpToNext) XP to next rank")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        } else {
                            Text("Max Rank Achieved!")
                                .font(.subheadline)
                                .foregroundColor(.green.opacity(0.8))
                        }

                        if !completedRecipes.isEmpty {
                            Text("Completed recipes: \(completedRecipes.count)")
                                .font(.subheadline)
                                .padding(.top, 4)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.vertical, 28)
                    .padding(.horizontal, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(.ultraThinMaterial.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                    )
                    .shadow(color: .black.opacity(0.6), radius: 25, x: 0, y: 20)

                    // Main navigation buttons
                    HStack(spacing: 40) {
                        NavigationLink {
                            RecipeListView()
                        } label: {
                            VStack(spacing: 8) {
                                Text("View Recipes")
                                    .font(.title2)
                                    .bold()
                                Text("Choose something to cook")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 40)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 0.98, green: 0.54, blue: 0.21),
                                             Color(red: 0.95, green: 0.26, blue: 0.33)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(28)
                            .shadow(color: Color.black.opacity(0.6), radius: 20, x: 0, y: 10)
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            AchievementsView()
                        } label: {
                            VStack(spacing: 8) {
                                Text("Achievements")
                                    .font(.title3)
                                    .bold()
                                Text("Badges & milestones")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 34)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white.opacity(0.08))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.5), radius: 16, x: 0, y: 8)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer()
                }
                .padding(.horizontal, 60)
            }
        }
    }
}
