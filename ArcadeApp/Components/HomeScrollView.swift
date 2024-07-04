import SwiftUI

struct HomeScrollView: View {
    @Environment(GamesVM.self) private var gamesVM
    
    let games: [Game]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                ForEach(games) { game in
                    GameCardButton(game: game, size: CGSize(width: 120, height: 175)) {
                        gamesVM.selectedGame = game
                    }
                }
            }
            .safeAreaPadding()
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    HomeScrollView(games: [.test])
        .environment(GamesVM(interactor: TestInteractor()))
}
