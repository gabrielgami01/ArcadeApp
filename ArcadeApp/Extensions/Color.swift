import SwiftUI

extension Color {
    static let backgroundGradient = RadialGradient(
        colors: [.background, .backgroundColor2],
        center: .center,
        startRadius: 30,
        endRadius: 380)
    
    static let cardGradient = LinearGradient(colors: [.card, .cardColor2], startPoint: .topLeading, endPoint: .bottomTrailing)
    
}
