import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let label: LocalizedStringKey
    var type: TextFieldType = .simple
    var capitalization: TextInputAutocapitalization = .never
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                switch type {
                    case .simple:
                        TextField(label, text: $text)
                    case .secured:
                        SecureField(label, text: $text)
                    case .search:
                        HStack(spacing: 10){
                            Image(systemName:"magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField(label, text: $text)
                        }
                }
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.plain)
                .opacity(text.isEmpty ? 0.0 : 1.0)
            }
            .font(.customBody)
            .textInputAutocapitalization(capitalization)
            .autocorrectionDisabled()
            .padding(10)
            .background(.quaternary.opacity(0.4), in: .rect(cornerRadius: 10))
        }
    }
}

#Preview {
    CustomTextField(text: .constant("gabrielgm"), label: "Username")
        .preferredColorScheme(.dark)
}
