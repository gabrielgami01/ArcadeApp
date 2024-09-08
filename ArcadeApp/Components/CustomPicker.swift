import SwiftUI

struct CustomPicker<T: Hashable & Identifiable & CaseIterable>: View where T.AllCases: RandomAccessCollection{
    @Binding var activeSelection: T
    let titleFormatter: (T) -> String
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(T.allCases) { option in
                Button {
                    withAnimation(.bouncy) {
                        activeSelection = option
                    }
                } label: {
                    Text(titleFormatter(option))
                        .font(.customHeadline)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background {
                            if let namespace {
                                if activeSelection == option {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.accentColor)
                                        .matchedGeometryEffect(id: "ACTIVEPICKER", in: namespace)
                                } else {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.cardGradient)
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
    CustomPicker(activeSelection: .constant(ProfilePage.followers)) {$0.rawValue}
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}
