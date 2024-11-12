import SwiftUI

fileprivate struct TabBarInset: ViewModifier {
    @Environment(\.tabBarHeight) private var tabBarHeight
    
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom) {
                Color.clear
                    .frame(height: tabBarHeight)
            }
    }
}

extension View {
    func tabBarInset() -> some View {
        modifier(TabBarInset())
    }
}
