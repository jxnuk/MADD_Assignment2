import SwiftUI

struct ConfettiView: View {
    @State private var animate = false

    private let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<50, id: \.self) { index in
                    let color = colors[index % colors.count]

                    RoundedRectangle(cornerRadius: 3)
                        .fill(color.opacity(0.9))
                        .frame(width: 8, height: 16)
                        .rotationEffect(.degrees(animate ? Double.random(in: 0...360) : 0))
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: animate ? geo.size.height + 80 : -80
                        )
                        .opacity(0.95)
                        .animation(
                            .interpolatingSpring(stiffness: 40, damping: 8)
                                .delay(Double(index) * 0.03),
                            value: animate
                        )
                }
            }
            .onAppear {
                animate = true
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
