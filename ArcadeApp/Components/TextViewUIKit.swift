import SwiftUI

struct TextViewUIKit: UIViewRepresentable {
    @Binding var text: String
    let maxLines: Int
    
    typealias UIViewType = UITextView
    
    final class Coordinator: NSObject, UITextViewDelegate {
        @Binding var texto: String
        
        init(texto: Binding<String>) {
            self._texto = texto
        }
        
        func textViewDidChange(_ textView: UITextView) {
            texto = textView.text
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(texto: $text)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.font = .preferredFont(forTextStyle: .callout)
        textView.textContainer.maximumNumberOfLines = maxLines
        textView.textContainer.lineBreakMode = .byClipping
        textView.text = text
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {}
}
