import SwiftUI

struct TabBarHeightKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    var tabBarHeight: CGFloat {
        get { self[TabBarHeightKey.self] }
        set { self[TabBarHeightKey.self] = newValue }
    }
}

extension View {
    func tabBarHeight(_ height: CGFloat) -> some View {
        environment(\.tabBarHeight, height)
    }
}
