import SwiftUI

fileprivate struct ErrorAlert: ViewModifier {
    @Binding var show: Bool
    var text: String? = nil
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Rectangle()
                    .fill(Color.secondary)
                    .ignoresSafeArea()
                    .opacity(show ? 0.2 : 0.0)
            }
            .overlay {
                VStack(spacing: 5) {
                    Text("OOOOOPS!")
                        .font(.customTitle)
                    
                    VStack {
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
                }
                .font(.customBody)
                .frame(width: 300, height: 150)
                .customCard(borderColor: .accent, cornerRadius: 10)
                .opacity(show ? 1.0 : 0.0)
                .offset(y: show ? 0 : 200)
            }
            .animation(.default, value: show)
    }
}

extension View {
    func errorAlert(show: Binding<Bool>, text: String? = nil) -> some View {
        modifier(ErrorAlert(show: show, text: text))
    }
}
