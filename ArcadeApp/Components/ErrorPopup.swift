import SwiftUI

fileprivate struct ErrorAlert: ViewModifier {
    @Binding var show: Bool
    var text: String?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if show {
                    VStack {
                        Text("Oooops!")
                            .font(.customTitle)
                        
                        Group {
                            if let text {
                                Text(text)
                            } else {
                                Text("Something went wrong.")
                            }
                        }
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        
                        Button {
                            show.toggle()
                        } label: {
                            Text("OK")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .font(.customBody)
                    .frame(width: 300, height: 150)
                    .customCard(borderColor: .accent, cornerRadius: 10)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.default, value: show)
    }
}

extension View {
    func showAlert(show: Binding<Bool>, text: String? = nil) -> some View {
        modifier(ErrorAlert(show: show, text: text))
    }
}
