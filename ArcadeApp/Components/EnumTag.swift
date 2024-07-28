import SwiftUI

fileprivate struct EnumTag: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.customCaption)
            .foregroundStyle(.white)
            .font(.customCaption)
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
