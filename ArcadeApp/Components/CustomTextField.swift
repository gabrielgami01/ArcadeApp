import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var value: String
    @Binding var isError: Bool
    let label: String
    var type: TextFieldType = .simple
    var capitalization: TextInputAutocapitalization = .never
    var validation: ((String) -> String?)? = nil

    @State private var error = false
    @State private var errorMsg = ""
    
    
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
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2.0)
                    .fill(.red)
                    .padding(2)
                    .opacity(error ? 1.0 : 0.0)
            }
            Text("\(label.capitalized) \(errorMsg).")
                .font(.caption2)
                .foregroundStyle(.red)
                .bold()
                .padding(.horizontal, 10)
                .opacity(error ? 1.0 : 0.0)
        }
        .onChange(of: value, initial: false) {
            if let validation {
                if let message = validation(value) {
                    error = true
                    errorMsg = message
                } else {
                    error = false
                    errorMsg = ""
                }
                isError = error
            }
        }
    }
}

#Preview {
    CustomTextField(value: .constant(""), isError: .constant(true), label: "Username") { value in
        if value.isEmpty {
            "cannot be empty"
        } else if value.count < 6 {
            "cannot be less than 6 characters"
        } else {
            nil
        }
    }
    .padding()
}
