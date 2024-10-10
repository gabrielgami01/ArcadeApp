import SwiftUI

struct GameDetailsLabel<Content: View>: View {
    @Binding var showAction: Bool
    let title: LocalizedStringKey
    @ViewBuilder var label: () -> Content
    
    var body: some View {
        HStack {
            Text(title)
                .font(.customTitle3)
                .bold()
            
            Spacer()
            
            Button {
                showAction = true
            } label: {
                label()
                    .font(.customBody)
            }
        }
    }
}

#Preview {
    GameDetailsLabel(showAction: .constant(false), title: "Player's Reviews") {
        Label {
            Text("Write a Review")
        } icon: {
            Image(systemName: "square.and.pencil")
        }
    }
    .preferredColorScheme(.dark)
}
