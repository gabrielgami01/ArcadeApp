import Foundation
import SwiftUI

enum TextFieldType {
    case simple
    case secured
}

struct CustomTextField: View {
    @Binding var value: String
    let label: String
    let type: TextFieldType
    var capitalization: TextInputAutocapitalization = .never
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                switch type {
                    case .simple:
                        TextField(label, text: $value)
                    case .secured:
                       SecureField(label, text: $value)
                }
                Button {
                    value = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.plain)
                .opacity(value.isEmpty ? 0.0 : 1.0)
            }
            .textInputAutocapitalization(capitalization)
            .autocorrectionDisabled()
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.quaternary)
                    .opacity(0.4)
            }
        }
        
    }
    
}

#Preview {
    CustomTextField(value: .constant(""), label: "Username", type: .simple)
        .padding()
}
