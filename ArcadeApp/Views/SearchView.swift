import SwiftUI

struct SearchView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Namespace private var myNamespace
    
    var body: some View {
        ZStack {
            GameListView()
                .opacity(gamesVM.selectedGame == nil ? 1.0 : 0.0)
            if let game = gamesVM.selectedGame {
                GameDetailsView(detailsVM: GameDetailsVM(game: game))
            }
        }
        .animation(.bouncy.speed(0.8), value: gamesVM.selectedGame)
        .namespace(myNamespace)
    }
}

#Preview {
    SearchView()
        .environment(GamesVM(interactor: TestInteractor()))
}
