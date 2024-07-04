import SwiftUI

struct GamesListView: View {
    let master: Master
    
    @Environment(GamesVM.self) private var gamesVM
    
    private let columns = Array(repeating: GridItem(spacing: 10), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(gamesVM.games) { game in
                    GameCardButton(game: game) {
                        gamesVM.selectedGame = game
                    }
                }
            }
        }
        .task {
            await gamesVM.getGamesByMaster(master: master)
        }
        .navigationTitle(master.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaPadding()
        .background(Color("backgroundColor"))
    }
}

#Preview {
    NavigationStack {
        GamesListView(master: Console.test)
    }
    .environment(GamesVM(interactor: TestInteractor()))
    .preferredColorScheme(.dark)
}



