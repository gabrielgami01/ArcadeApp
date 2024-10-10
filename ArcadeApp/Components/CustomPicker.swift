import SwiftUI

struct CustomPicker<T: Hashable & Identifiable & CaseIterable>: View where T.AllCases: RandomAccessCollection {
    @Binding var selected: T
    let displayKeyPath: KeyPath<T, String>
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(T.allCases) { option in
                Button {
                    withAnimation(.bouncy) {
                        selected = option
                    }
                } label: {
                    let item = option[keyPath: displayKeyPath]
                    Text(LocalizedStringKey(item.capitalized))
                        .font(.customHeadline)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background {
                            if let namespace {
                                if selected == option {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.accentColor)
                                        .matchedGeometryEffect(id: "ACTIVEPICKER", in: namespace)
                                } else {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.card)
                                }
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    CustomPicker(selected: .constant(ConnectionOptions.followers), displayKeyPath: \.rawValue)
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}
