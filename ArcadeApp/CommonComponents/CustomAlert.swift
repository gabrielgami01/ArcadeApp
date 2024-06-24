import SwiftUI

fileprivate struct CustomAlert: ViewModifier {
    @Binding var show: Bool
    let text: String
    
    func body(content: Content) -> some View {
        content
            .alert("Warning",
                   isPresented: $show) {} message: {
                Text(text)
            }
    }
}

extension View {
    func showAlert(show: Binding<Bool>, text: String) -> some View {
        modifier(CustomAlert(show: show, text: text))
    }
}
