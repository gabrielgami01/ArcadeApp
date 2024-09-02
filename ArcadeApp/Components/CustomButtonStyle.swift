import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.customHeadline)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isEnabled ? .card : .secondary)
                    .overlay {
                        if isEnabled {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.accent, lineWidth: 3)
                        }
                    }
                    .frame(width: 250)
            }
            .foregroundColor(isEnabled ? .white : .black)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .shadow(color: isEnabled ? .accent.opacity(0.6) : .white.opacity(0.6), radius: 5)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .animation(.default, value: isEnabled)
            
    }
}
