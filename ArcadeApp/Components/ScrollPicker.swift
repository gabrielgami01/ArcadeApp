import SwiftUI

struct ScrollPicker<T: Pickeable>: View where T.AllCases: RandomAccessCollection {
    @Binding var selected: T
    
    @Namespace private var namespace
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(T.allCases) { option in
                    Button {
                        selected = option
                    } label: {
                        Text(LocalizedStringKey(option.displayName))
                    }
                    .buttonStyle(SelectorStyle(isActive: selected == option, namespace: namespace))
                }
            }
            .animation(.smooth, value: selected)
            .frame(height: 30)
            .safeAreaPadding(.horizontal)
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    ScrollPicker(selected: .constant(Console.all))
        .preferredColorScheme(.dark)
}

struct SelectorStyle: ButtonStyle {
    let isActive: Bool
    let namespace: Namespace.ID

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.customSubheadline)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .frame(width: 110)
            .background {
                if isActive {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.accentColor)
                        .matchedGeometryEffect(id: "SCROLLSELECTOR", in: namespace)
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.card)
                        .stroke(.accent, lineWidth: 2)
                }
            }
    }
}
