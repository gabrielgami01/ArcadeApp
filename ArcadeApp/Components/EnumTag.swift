import SwiftUI

fileprivate struct EnumTag: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundStyle(.white)
            .font(.caption)
            .padding(5)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.primary)
            }
    }
}

extension View {
    func enumTag() -> some View {
        modifier(EnumTag())
    }
}
