import SwiftUI

struct MainMenuView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple.opacity(0.7), .blue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                VStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Text("SwiftRun AI")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    
                    Text("AI-Powered Endless Runner")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.subheadline)
                }
                .padding(.top, 30)
                
                VStack(spacing: 20) {
                    NavigationLink {
                        GameView()
                    } label: {
                        menuButton(icon: "gamecontroller.fill", text: "Play")
                    }
                    
                    NavigationLink {
                        StatsView()
                    } label: {
                        menuButton(icon: "chart.bar.xaxis", text: "Stats & History")
                    }
                    
                    NavigationLink {
                        RunChartsView()
                    } label: {
                        menuButton(icon: "chart.line.uptrend.xyaxis", text: "Performance Charts")
                    }
                    
                    NavigationLink {
                        SettingsView()
                    } label: {
                        menuButton(icon: "gear", text: "Settings")
                    }
                    
                    NavigationLink {
                        HowToPlayView()
                    } label: {
                        menuButton(icon: "questionmark.circle", text: "How To Play")
                    }
                    
                    NavigationLink {
                        CreditsView()
                    } label: {
                        menuButton(icon: "person.3.sequence.fill", text: "Credits")
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func menuButton(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title2.bold())
            Text(text)
                .font(.title3.bold())
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white.opacity(0.18))
        .cornerRadius(14)
        .shadow(radius: 5)
    }
}

#Preview {
    NavigationStack { MainMenuView() }
}
