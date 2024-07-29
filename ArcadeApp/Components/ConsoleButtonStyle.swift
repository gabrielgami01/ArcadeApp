import SwiftUI

struct ConsoleButtonStyle: ButtonStyle {
    let isActive: Bool
    let namespace: Namespace.ID

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.customSubheadline)
            .foregroundColor(isActive ? .black : .white)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .frame(width: 110)
            .background(
                ZStack {
                    if isActive {
                        Capsule()
                            .fill(Color.cyan)
                            .matchedGeometryEffect(id: "ACTIVECONSOLE", in: namespace)
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                    } else {
                        Capsule()
                            .fill(Color.black.opacity(0.7))
                            .overlay(
                                Capsule()
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
