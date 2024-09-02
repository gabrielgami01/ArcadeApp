import SwiftUI

fileprivate struct ErrorAlert: ViewModifier {
    @Binding var show: Bool
    let text: String
    
    func body(content: Content) -> some View {
        content
            .alert("ERROR",
                   isPresented: $show) {} message: {
                Text(text)
            }
    }
}

extension View {
    func showAlert(show: Binding<Bool>, text: String) -> some View {
        modifier(ErrorAlert(show: show, text: text))
    }
}
