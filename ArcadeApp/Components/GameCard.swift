import SwiftUI

struct GameCard: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading) {
            GameCover(game: game)
            Text(game.name)
                .font(.footnote)
        }
    }
}

#Preview {
    GameCard(game: .test)
}
