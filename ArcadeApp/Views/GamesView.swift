import SwiftUI

struct GamesView: View {
    let master: Master
    
    @State var searchVM: SearchVM
    
    private let columns = Array(repeating: GridItem(spacing: 10), count: 2)

    var body: some View {
        if let game = searchVM.selectedGame {
            GameDetailsView(game: game)
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(searchVM.games) { game in
                        Button {
                            searchVM.selectedGame = game
                        } label: {
                            GameCard(game: game)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .task {
                await searchVM.getGamesByMaster(master: master)
            }
            .navigationTitle(master.name)
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding()
        }
    }
}

#Preview {
    NavigationStack {
        GamesView(master: Console.test, searchVM: SearchVM(interactor: TestInteractor()))
    }
}



