import SwiftUI

struct AsyncText: View {
    @Binding var text: String
    let label: String
    let font: Font

    var body: some View {
        Text(text)
            .font(font)
            .task {
                if text.isEmpty {
                    do {
                        let textBox = AsyncTypeWriter(message: label)
                        for try await txt in textBox {
                            text = txt
                        }
                        try await Task.sleep(for: .seconds(0.5))
                    } catch {
                        print("Error en la tarea asíncrona: \(error)")
                    }
                }
            }
    }
}

#Preview {
    AsyncText(text: .constant("ARCADE STUDIOS"), label: "ARCADE STUDIOS", font: .customLargeTitle)
        .preferredColorScheme(.dark)
}
   
