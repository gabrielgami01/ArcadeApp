import SwiftUI

struct GameDescriptionCard: View {
    let game: Game
    
    var body: some View {
        ScrollView {
            Text(game.description)
                .font(.customCaption)
                .foregroundColor(.white)
                .padding()
        }
        .scrollBounceBehavior(.basedOnSize)
        .customCard()
        
    }
}
#Preview {
    GameDescriptionCard(game: .test)
        .frame(width: 150, height: 220)
}
