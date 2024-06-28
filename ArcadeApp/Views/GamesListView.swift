import SwiftUI

struct GamesListView: View {
    let master: Master
    
    @State var searchVM: SearchVM
    
    private let columns = Array(repeating: GridItem(spacing: 10), count: 2)

    var body: some View {
        if let game = searchVM.selectedGame {
            Text(game.name)
            Button {
                searchVM.selectedGame = nil
            } label: {
                Text("Back")
            }
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
        GamesListView(master: Console.test, searchVM: SearchVM(interactor: TestInteractor()))
    }
}

struct GameCover: View {
    let game: Game
    
    var body: some View {
        Group {
            if let image = game.imageURL {
                
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(white: 0.9))
                    .overlay {
                        Image(systemName: "gamecontroller")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.secondary)
                            .padding()
                    }
            }
        }
        .frame(width: 160, height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .primary.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

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
