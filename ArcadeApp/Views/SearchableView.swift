import SwiftUI
import SwiftData

struct SearchableView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(SearchVM.self) private var searchVM
    @Environment(\.modelContext) private var context
    @FocusState private var focus: Bool
    
    @Query(sort: [SortDescriptor(\GameModel.added, order: .reverse)]) private var recentSearchs: [GameModel]
    
    var body: some View {
        @Bindable var bvm = searchVM
        
        ScrollView {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    CustomTextField(value: $bvm.search, isError: .constant(false), label: "Search", type: .search)
                        .focused($focus)
                    Button {
                        searchVM.showSearch.toggle()
                        searchVM.search.removeAll()
                    } label: {
                        Text("Cancel")
                            .font(.customTitle3)
                    }
                }
                .padding(.top, 5)
                
                Group {
                    if searchVM.search.isEmpty {
                        if recentSearchs.isEmpty {
                            CustomUnavailableView(title: "Search games", image: "gamecontroller", description: "Search for games by name.")
                        } else {
                            LazyVStack {
                                ForEach(recentSearchs) { gameModel in
                                    let game = gameModel.toGame
                                    SearchCell(game: game, isRecent: true)
                                }
                            }
                        }
                    } else {
                        if searchVM.games.isEmpty {
                            CustomUnavailableView(title: "No results for '\(searchVM.search)'", image: "magnifyingglass", description: "Check the spelling or try a new search.")
                        } else {
                            LazyVStack(alignment: .leading) {
                                ForEach(searchVM.games) { game in
                                    SearchCell(game: game, isRecent: false)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            focus.toggle()
        }
        .background(Color.background)
    }
}

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
                    GameSearchableButton(game: game)
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
    SearchableView()
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(SearchVM(interactor: TestInteractor()))
}
