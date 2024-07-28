import SwiftUI

fileprivate struct Shimmer: ViewModifier {
    let animation: Animation = Animation.linear(duration: 2).repeatForever(autoreverses: false)
    let gradient: Gradient = Gradient(colors: [Color.white.opacity(0.0), Color.white.opacity(0.9), Color.white.opacity(0.0)])
    let min: CGFloat
    let max: CGFloat
    @State private var shimmerOffset: CGFloat = -1
    
    init(bandSize: CGFloat = 0.3) {
        self.min = 0 - bandSize
        self.max = 1 + bandSize
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let width = geometry.size.width
                    LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                        .mask(
                            Rectangle()
                                .fill(LinearGradient(gradient: gradient, startPoint: UnitPoint(x: shimmerOffset, y: 0.5), endPoint: UnitPoint(x: shimmerOffset + 1, y: 0.5)))
                                .frame(width: width)
                                .offset(x: width * shimmerOffset)
                        )
                }
                .onAppear {
                    startShimmer()
                }
            )
    }
    
    private func startShimmer() {
        withAnimation(animation) {
            shimmerOffset = 2
        }
    }
}

extension View {
    func shimmerEffect() -> some View {
        self.modifier(Shimmer())
    }
}
