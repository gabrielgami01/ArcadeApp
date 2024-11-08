import SwiftUI

struct TextFieldStyleButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.customBody)
            .padding(10)
            .background(.quaternary.opacity(0.4), in: .rect(cornerRadius: 10))
            .padding(.horizontal)
            .padding(.bottom, 5)
            .background(Color.background)
    }
}

