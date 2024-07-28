import SwiftUI

struct AsyncText: View {
    @State var text = ""
    let label: String
    let font: Font
    
    var body: some View {
        Text(text)
            .font(font)
            .task {
                let textBox = AsyncTypeWriter(message: label)
                do {
                    for try await txt in textBox {
                        text = txt
                    }
                } catch {
                    
                }
            }
    }
}

#Preview {
    AsyncText(label: "ARCADE STUDIOS", font: .customLargeTitle)
}
