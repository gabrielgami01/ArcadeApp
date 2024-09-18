import SwiftUI

fileprivate struct StickyHeader: ViewModifier {    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, UIDevice.topInset)
            .padding(.bottom, 5)
            .background(Color.backgroundColor)
    }
}

extension View {
    func stickyHeader() -> some View {
        modifier(StickyHeader())
    }
}

