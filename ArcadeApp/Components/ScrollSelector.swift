import SwiftUI

struct ScrollSelector<T: Hashable & Identifiable & CaseIterable>: View where T.AllCases: RandomAccessCollection {
    @Binding var activeSelection: T
    let titleFormatter: (T) -> String
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(T.allCases) { item in
                    if let namespace {
                        Button {
                            withAnimation(.smooth) {
                                activeSelection = item
                            }
                        } label: {
                            Text(titleFormatter(item))
                                .font(.customCaption2)
                        }
                        .buttonStyle(SelectorStyle(isActive: activeSelection == item, namespace: namespace))
                    }
                }
            }
            .frame(height: 30)
            .safeAreaPadding(.horizontal)
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    ScrollSelector(activeSelection: .constant(Console.all)) { $0.rawValue }
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}
