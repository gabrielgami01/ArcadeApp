import SwiftUI

struct TextFieldStyleButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.customTitle3)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.quaternary)
                    .opacity(0.4)
            }
            .padding(.horizontal)
    }
}

