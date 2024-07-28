import SwiftUI

fileprivate struct CustomCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.accent, lineWidth: 3)
                    )
            }
    }
}

extension View {
    func customCard() -> some View {
        modifier(CustomCard())
    }
}
