import SwiftUI

fileprivate struct CustomCard: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.cardColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(color, lineWidth: 3)
                    )
            }
    }
}

extension View {
    func customCard(borderColor: Color, cornerRadius: CGFloat) -> some View {
        modifier(CustomCard(color: borderColor, cornerRadius: cornerRadius))
    }
}
