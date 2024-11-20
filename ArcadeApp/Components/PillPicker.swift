import SwiftUI

struct PillPicker<T: Pickeable>: View where T.AllCases: RandomAccessCollection {
    @Binding var selected: T
    
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(T.allCases) { option in
                Button {
                    withAnimation(.bouncy) {
                        selected = option
                    }
                } label: {
                    HStack {
                        if let image = option.displayImage {
                            Image(systemName: image)
                        }

                        if selected == option {
                            Text(LocalizedStringKey(option.displayName.capitalized))
                        }
                            
                    }
                }
                .buttonStyle(PillStyle(isActive: option == selected, namespace: namespace))
            }
        }
    }
}

#Preview {
    PillPicker(selected: .constant(GameOptions.about))
        .preferredColorScheme(.dark)
}

struct PillStyle: ButtonStyle {
    let isActive: Bool
    let namespace: Namespace.ID

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.customHeadline)
            .padding(8)
            .frame(maxWidth: isActive ? .infinity : nil)
            .background {
                if isActive {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.accentColor)
                        .matchedGeometryEffect(id: "PILLPICKER", in: namespace)
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.card)
                }
            }
    }
}
