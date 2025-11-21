import SwiftUI

struct StatsView: View {
    @State private var runs: [Run] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Stats & History")
                .font(.largeTitle.bold())
            
            NavigationLink("View Performance Charts") {
                RunChartsView()
            }
            .buttonStyle(.borderedProminent)
            
            if runs.isEmpty {
                Text("No runs recorded yet.")
                    .foregroundStyle(.secondary)
                    .padding(.top)
            } else {
                List {
                    ForEach(runs, id: \.id) { run in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(run.date?.formatted() ?? "-")
                                    .font(.headline)
                                Text("Distance: \(Int(run.distance)) m")
                                Text("Score: \(run.coinsCollected)")
                            }
                            Spacer()
                            Image(systemName: "arrow.right.circle")
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .onAppear {
            runs = RunStorage.shared.fetchRuns()
        }
        .padding()
    }
}

#Preview { StatsView() }
