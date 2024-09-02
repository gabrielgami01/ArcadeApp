import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let label: String
    var type: TextFieldType = .simple
    var capitalization: TextInputAutocapitalization = .never
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                switch type {
                    case .simple:
                        TextField(label, text: $text)
                            .font(.customBody)
                    case .secured:
                        SecureField(label, text: $text)
                             .font(.customBody)
                    case .search:
                        HStack(spacing: 10){
                            Image(systemName:"magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField(label, text: $text)
                        }
                        .font(.customBody)
                }
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.plain)
                .opacity(text.isEmpty ? 0.0 : 1.0)
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
    CustomTextField(text: .constant("gabrielgm"), label: "Username")
        .preferredColorScheme(.dark)
}
