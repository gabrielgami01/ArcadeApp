import SwiftUI

struct CustomPicker<T: Pickeable>: View where T.AllCases: RandomAccessCollection {
    @Binding var selected: T
    
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(T.allCases) { option in
                Button {
                    withAnimation(.bouncy) {
                        selected = option
                    }
                } label: {
                    Text(LocalizedStringKey(option.displayName.capitalized))
                }
                .buttonStyle(PickerStyle(isActive: selected == option, namespace: namespace))
            }
        }
    }
}

#Preview {
    CustomPicker(selected: .constant(ConnectionOptions.followers))
        .preferredColorScheme(.dark)
}

struct PickerStyle: ButtonStyle {
    let isActive: Bool
    let namespace: Namespace.ID

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.customHeadline)
            .padding(5)
            .frame(maxWidth: .infinity)
            .background {
                if isActive {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.accentColor)
                        .matchedGeometryEffect(id: "CUSTOMPICKER", in: namespace)
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.card)
                }
            }
    }
}
