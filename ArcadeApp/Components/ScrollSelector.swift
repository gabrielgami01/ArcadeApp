import SwiftUI

struct ScrollSelector<T: Hashable & Identifiable & CaseIterable>: View where T.AllCases: RandomAccessCollection {
    @Binding var selected: T
    let displayKeyPath: KeyPath<T, String>
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(T.allCases) { option in
                    if let namespace {
                        Button {
                            selected = option
                        } label: {
                            let item = option[keyPath: displayKeyPath]
                            Text(item.capitalized)
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
    ScrollSelector(selected: .constant(Console.all), displayKeyPath: \.rawValue)
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}
