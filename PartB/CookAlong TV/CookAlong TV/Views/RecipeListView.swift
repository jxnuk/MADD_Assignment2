import SwiftUI
import CoreData

struct RecipeListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CompletedRecipe.completedAt, ascending: false)]
    ) private var completedRecipes: FetchedResults<CompletedRecipe>

    private var completedIDs: Set<String> {
        Set(completedRecipes.compactMap { $0.id })
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.07, green: 0.09, blue: 0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 30) {
                Text("Choose a Recipe")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                Text("Scroll sideways to explore all your dishes.")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.7))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 40) {
                        ForEach(sampleRecipes) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                RecipeCard(recipe: recipe, isCompleted: completedIDs.contains(recipe.id))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 40)
                }

                Spacer()
            }
            .padding(.horizontal, 60)
        }
        .navigationTitle("Recipes")
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    let isCompleted: Bool
    @State private var isFocused: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack(alignment: .topTrailing) {
                Image(recipe.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 420, height: 250)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.black.opacity(0.0), .black.opacity(0.5)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(24)

                if isCompleted {
                    Text("Completed")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.85))
                        .cornerRadius(14)
                        .padding(12)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                HStack(spacing: 8) {
                    Text(recipe.category.displayName)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(12)

                    Text(recipe.difficulty.displayName)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            LinearGradient(
                                colors: difficultyColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                .foregroundColor(.white.opacity(0.9))
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.white.opacity(0.04))
                .shadow(color: .black.opacity(isFocused ? 0.6 : 0.3), radius: isFocused ? 24 : 12, x: 0, y: isFocused ? 16 : 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(isFocused ? Color.white.opacity(0.6) : Color.white.opacity(0.08), lineWidth: isFocused ? 2 : 1)
        )
        .scaleEffect(isFocused ? 1.04 : 1.0)
        .animation(.spring(response: 0.28, dampingFraction: 0.8), value: isFocused)
        .focusable(true) { focus in
            isFocused = focus
        }
    }

    private var difficultyColors: [Color] {
        switch recipe.difficulty {
        case .beginner:
            return [Color.green.opacity(0.8), Color.green]
        case .intermediate:
            return [Color.orange, Color(red: 0.95, green: 0.6, blue: 0.2)]
        case .advanced:
            return [Color.red, Color.pink]
        }
    }
}
