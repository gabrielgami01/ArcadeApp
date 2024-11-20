import SwiftUI

extension EnvironmentValues {
     @Entry var tabBarHeight: CGFloat = 0
}

extension View {
    func tabBarHeight(_ height: CGFloat) -> some View {
        environment(\.tabBarHeight, height)
    }
}
