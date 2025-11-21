import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.09, green: 0.07, blue: 0.16)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                ZStack(alignment: .bottomLeading) {
                    Image(recipe.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 900, height: 460)
                        .clipped()
                        .cornerRadius(32)
                        .shadow(color: .black.opacity(0.7), radius: 30, x: 0, y: 24)

                    LinearGradient(
                        colors: [.black.opacity(0.0), .black.opacity(0.7)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .cornerRadius(32)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(recipe.name)
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)

                        HStack(spacing: 10) {
                            TagView(text: recipe.category.displayName, icon: "fork.knife")
                            TagView(text: recipe.difficulty.displayName, icon: "flame.fill")
                        }
                    }
                    .padding(24)
                }

                NavigationLink {
                    StepView(recipe: recipe)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                        Text("Start Cooking")
                            .font(.title2)
                            .bold()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 40)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.96, green: 0.55, blue: 0.26),
                                     Color(red: 0.92, green: 0.2, blue: 0.44)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.6), radius: 22, x: 0, y: 12)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.horizontal, 60)
            .padding(.top, 40)
        }
    }
}

private struct TagView: View {
    let text: String
    let icon: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.16))
        .foregroundColor(.white.opacity(0.9))
        .cornerRadius(12)
    }
}
