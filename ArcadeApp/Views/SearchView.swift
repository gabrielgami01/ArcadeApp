import SwiftUI

struct SearchView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(SearchVM.self) private var searchVM
    @Namespace private var myNamespace
    
    var body: some View {
        ZStack {
            ZStack {
                GameListView()
                    .opacity(searchVM.showSearch ? 0.0 : 1.0)
                SearchableView()
                    .opacity(searchVM.showSearch ? 1.0 : 0.0)
            }
            .opacity(gamesVM.selectedGame == nil ? 1.0 : 0.0)
            .animation(.easeInOut, value: searchVM.showSearch)
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
        .environment(SearchVM(interactor: TestInteractor()))
}
