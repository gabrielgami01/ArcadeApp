import SwiftUI

fileprivate struct EnumTag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.customFootnote)
            .padding(5)
            .background(Color.black.opacity(0.7))
            .cornerRadius(5)
            .foregroundColor(.accent)
    }
}

extension View {
    func enumTag() -> some View {
        modifier(EnumTag())
    }
}
