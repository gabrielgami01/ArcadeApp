import SwiftUI

struct SearchCell: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(SearchVM.self) private var searchVM
    @Environment(\.modelContext) private var context

    let game: Game
    let isRecent: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    gamesVM.selectedGame = game
                    if !isRecent {
                        try? searchVM.saveGameSearch(game: game, context: context)
                    }
                } label: {
                    HStack(spacing: 10) {
                        GameCover(game: game, width: 60, height: 60)
                            .namespace(nil)
                        Text(game.name)
                            .font(.customBody)
                    }
                }
                
                Spacer()
                
                if isRecent {
                    Button {
                        try? searchVM.deleteGameSearch(game: game, context: context)
                    } label: {
                        Text("X")
                            .font(.customTitle)
                    }
                }
            }
            .buttonStyle(.plain)
    
            Divider()
        }
    }
}

#Preview {
    SearchCell(game: .test, isRecent: true)
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(SearchVM(interactor: TestInteractor()))
}
