import SwiftUI

fileprivate struct Shimmer: ViewModifier {
    let animation: Animation = Animation.linear(duration: 2).repeatForever(autoreverses: false)
    let gradient: Gradient = Gradient(colors: [.clear, .white, .clear])
    let active: Bool
    @State private var shimmerOffset: CGFloat = -1
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let width = geometry.size.width
                    LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
                        .mask(
                            Rectangle()
                                .fill(LinearGradient(gradient: gradient, startPoint: UnitPoint(x: shimmerOffset, y: shimmerOffset),
                                                     endPoint: UnitPoint(x: shimmerOffset + 1, y: shimmerOffset + 1)))
                                .frame(width: width * 2)
                                .offset(x: width * shimmerOffset)
                        )
                }
                .onAppear {
                    if active {
                        withAnimation(animation) { shimmerOffset = 2 }
                    }
                }
            )
    }
    

}

extension View {
    func shimmerEffect(active: Bool) -> some View {
        self.modifier(Shimmer(active: active))
    }
}

