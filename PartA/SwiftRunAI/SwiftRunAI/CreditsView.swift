import SwiftUI

struct CreditsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Credits")
                .font(.largeTitle.bold())
            
            VStack(spacing: 8) {
                Text("Developed By")
                    .font(.title2.bold())
                
                Text("Dissanayaka J.S")
                    .font(.title3)
                
                Text("BSc Hons in Interactive Media (MADD)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Credits")
    }
}

#Preview {
    NavigationStack { CreditsView() }
}
