import SwiftUI

struct PillPicker: View{
    @Binding var selected: GameOptions
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(GameOptions.allCases) { option in
                Button {
                    withAnimation(.bouncy) {
                        selected = option
                    }
                } label: {
                    HStack {
                        Image(systemName: option.image)
                            .font(.customHeadline)
                        
                        if selected == option {
                            Text(LocalizedStringKey(option.rawValue.capitalized))
                                .font(.customHeadline)
                        }
                            
                    }
                    .padding(8)
                    .frame(maxWidth: selected == option ? .infinity : nil)
                    .background {
                        if let namespace {
                            if selected == option {
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
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    PillPicker(selected: .constant(GameOptions.about))
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}
