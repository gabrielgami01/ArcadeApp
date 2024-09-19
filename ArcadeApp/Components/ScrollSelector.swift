import SwiftUI

struct ScrollSelector: View {
    @Binding var selected: Console
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(Console.allCases) { option in
                    if let namespace {
                        Button {
                            selected = option
                        } label: {
                            Text(option.rawValue)
                                .font(.customCaption2)
                        }
                        .buttonStyle(SelectorStyle(isActive: selected == option, namespace: namespace))
                    }
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
    ScrollSelector(selected: .constant(Console.all))
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}
