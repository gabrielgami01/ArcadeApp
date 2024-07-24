import SwiftUI
import SwiftData

struct GameListView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(\.modelContext) private var context
    @State var searchVM = SearchVM()
    
    @Query(sort: [SortDescriptor(\GameModel.added, order: .reverse)]) private var recentSearchs: [GameModel]
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        @Bindable var bvm = searchVM
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    // ConsoleTags
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 10) {
                            ForEach(Console.allCases) { console in
                                if let namespace{
                                    Button {
                                        withAnimation(.interactiveSpring(
                                            response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)
                                        ) {
                                            gamesVM.activeConsole = console
                                        }
                                    } label: {
                                        Text(console.rawValue)
                                            .font(.caption2)
                                    }
                                    .buttonStyle(ConsoleButtonStyle(isActive: gamesVM.activeConsole == console, namespace: namespace))
                                }
                            }
                        }
                        .frame(height: 30)
                        .safeAreaPadding(.horizontal)
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    //GameCards
                    LazyVStack(spacing: 20) {
                        ForEach(gamesVM.games) { game in
                            Button {
                                gamesVM.selectedGame = game
                            } label: {
                                GameCard(game: game)
                                    .padding(.leading)
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                gamesVM.isLastItem(game: game)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Search")
            .onChange(of: gamesVM.activeConsole, { oldValue, newValue in
                withAnimation(.default) {
                    gamesVM.getGames(console: newValue)
                }
            })
            .searchable(text: $bvm.search, placement: .navigationBarDrawer(displayMode: .always)) {
                if searchVM.search == "" {
                    if recentSearchs.isEmpty {
                        ContentUnavailableView("Search games", systemImage: "gamecontroller",
                                               description: Text("Search for games by name."))
                    } else {
                        ForEach(recentSearchs) { game in
                            HStack {
                                Button {
    //                                gamesVM.selectedGame = game
                                } label: {
    //                                GameSearchableButton(game: game)
                                    Text(game.name)
                                        .font(.body)
                                }
                                
                                Button {
                                    try? searchVM.deleteGameSearch(game: game, context: context)
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.body)
                                }
                            }
                        }
                        CustomButton(label: "Clear recent searches") {
                            try? searchVM.deleteGameSearch(context: context)
                        }
                    }
                } else {
                    if searchVM.games.isEmpty {
                        ContentUnavailableView("No games", systemImage: "gamecontroller",
                                               description: Text("There's no games with the name you introduced."))
                        
                    } else {
                        ForEach(searchVM.games) { game in
                            Button {
                                gamesVM.selectedGame = game
                                try? searchVM.saveGameSearch(game: game, context: context)
                            } label: {
                                GameSearchableButton(game: game)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .onChange(of: searchVM.search) { oldValue, newValue in
                searchVM.searchGame(name: newValue)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    GameListView(searchVM: SearchVM(interactor: TestInteractor()))
        .environment(GamesVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
}

struct GameSearchableButton: View {
    let game: Game
    
    var body: some View {
        HStack(spacing: 10) {
            GameCover(game: game, width: 60, height: 60)
                .namespace(nil)
            Text(game.name)
                .font(.body)
        }
    }
}
