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
                            withAnimation(.interactiveSpring(
                                response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)
                            ) {
                                activeSelection = item
                            }
                        } label: {
                            Text(titleFormatter(item))
                                .font(.customCaption2)
                        }
                        .buttonStyle(ConsoleButtonStyle(isActive: activeSelection == item, namespace: namespace))
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
}
