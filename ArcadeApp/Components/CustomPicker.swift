import SwiftUI

struct CustomPicker: View {
    @Environment(\.namespace) private var namespace
    @Binding var selectedOption: PickerOptions
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(PickerOptions.allCases) { option in
                Button {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
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
}
