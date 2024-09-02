import SwiftUI

struct CustomPicker: View {
    @Binding var selectedOption: PickerOptions
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(PickerOptions.allCases) { option in
                Button {
                    withAnimation(.bouncy) {
                        selectedOption = option
                    }
                } label: {
                    Text(option.rawValue)
                        .font(.customHeadline)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background {
                            if let namespace {
                                if selectedOption == option {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.accentColor)
                                        .matchedGeometryEffect(id: "ACTIVEPICKER", in: namespace)
                                } else {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.cardColor)
                                }
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
    }
}

#Preview {
    CustomPicker(selectedOption: .constant(.about))
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}
