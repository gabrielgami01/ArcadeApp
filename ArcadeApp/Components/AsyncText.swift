import SwiftUI

struct AsyncText: View {
    @State private var text = ""
    let label: String
    let font: Font
    var onCompletion: (() -> Void)?
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        Text(text)
            .font(font)
            .task {
                do {
                    let textBox = AsyncTypeWriter(message: label)
                    for try await txt in textBox {
                        text = txt
                    }
                    try await Task.sleep(for: .seconds(0.5))
                    onCompletion?()
                } catch {
                    print("Error en la tarea asíncrona: \(error)")
                }
            }
    }
}

#Preview {
    AsyncText(label: "ARCADE STUDIOS", font: .customLargeTitle)
}
