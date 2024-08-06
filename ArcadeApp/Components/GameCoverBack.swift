import SwiftUI

struct GameCoverBack: View {
    let game: Game
    
    var body: some View {
        ScrollView {
            Text(game.description)
                .font(.customCaption)
                .padding()
        }
        .scrollBounceBehavior(.basedOnSize)
        .customCard(borderColor: .accent, cornerRadius: 10)
    }
}
#Preview {
    GameCoverBack(game: .test)
        .frame(width: 150, height: 220)
}
