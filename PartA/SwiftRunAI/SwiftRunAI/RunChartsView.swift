import SwiftUI
import Charts

struct RunChartsView: View {
    @State private var runs: [Run] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Charts")
                .font(.title.bold())
            
            if runs.isEmpty {
                Text("Not enough data yet. Play a few runs first!")
                    .foregroundStyle(.secondary)
            } else {
                // Distance over time
                Text("Distance Over Time")
                    .font(.headline)
                
                Chart(runs, id: \.id) { run in
                    LineMark(
                        x: .value("Date", run.date ?? Date()),
                        y: .value("Distance (m)", run.distance)
                    )
                }
                .frame(height: 220)
                
                // Score over time
                Text("Score Per Run")
                    .font(.headline)
                
                Chart(runs, id: \.id) { run in
                    BarMark(
                        x: .value("Date", run.date ?? Date()),
                        y: .value("Score", run.coinsCollected)
                    )
                }
                .frame(height: 220)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            runs = RunStorage.shared.fetchRuns()
        }
        .navigationTitle("Charts")
    }
}

#Preview {
    NavigationStack {
        RunChartsView()
    }
}
