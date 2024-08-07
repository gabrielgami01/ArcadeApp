import SwiftUI

struct CustomButton: View {
    let label: String
    let actions: () -> Void
    
    var body: some View {
        Button {
            actions()
        } label: {
            Text(label)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(ChunkyButon())
    }
}

#Preview {
    CustomButton(label: "Login", actions: {})
}


struct ChunkyButon: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.customTitle3)
            .padding(10)
            .background() {
                ZStack {
                    Capsule()
                        .fill(Color.cardColor)
                        .stroke(.white, lineWidth: 3)
                        .offset(y: configuration.isPressed ? 0 : 10)
                    Capsule()
                        .fill(isEnabled ? Color.accent : Color.gray)
                        .stroke(.white, lineWidth: 3)
                }
            }
            .offset(y: configuration.isPressed ? 10 : 0)
            .padding(.horizontal)
    }
}

struct TextFieldButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.customTitle3)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.quaternary)
                    .opacity(0.4)
            }
            .padding()
    }
}
