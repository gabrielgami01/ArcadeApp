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
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.customTitle3)
            .padding(10)
            .background() {
                ZStack {
                    Capsule()
                        .fill(Color(white: 0.05))
                        .stroke(.white, lineWidth: 3)
                        .offset(y: configuration.isPressed ? 0 : 10)
                    Capsule()
                        .fill(.accent)
                        .stroke(.white, lineWidth: 3)
                }
            }
            .offset(y: configuration.isPressed ? 10 : 0)
            .padding(.horizontal)
    }
}
