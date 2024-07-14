import SwiftUI

struct ConsoleButtonStyle: ButtonStyle {
    let isActive: Bool
    let namespace: Namespace.ID

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .padding(.vertical, 5)
            .frame(width: 110)
            .background(
                ZStack {
                    if isActive {
                        Capsule()
                            .fill(.blue)
                            .matchedGeometryEffect(id: "ACTIVECONSOLE", in: namespace)
                    } else {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                    }
                }
            )
    }
}
