import SwiftUI

extension UIDevice {
    @MainActor static var width: CGFloat {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .screen
            .bounds
            .width ?? 0
    }
    
    @MainActor static var topInset: CGFloat {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .safeAreaInsets
            .top ?? 0
    }
}
