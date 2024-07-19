import SwiftUI
import SwiftData

struct GameListView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(\.modelContext) private var context
    @State var searchVM = SearchVM()
    
    @Query(sort: [SortDescriptor(\GameModel.added, order: .reverse)]) private var searched: [GameModel]
    
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
                                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
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
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(gamesVM.games) { game in
                                //Text(gamesVM.games.count.formatted())
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
            }
            .navigationTitle("Search")
            .onChange(of: gamesVM.activeConsole, { oldValue, newValue in
                withAnimation(.default) {
                    gamesVM.getGames(console: newValue)
                }
            })
            .searchable(text: $bvm.search, placement: .navigationBarDrawer(displayMode: .always)) {
                if searchVM.search == "" {
                    if searched.isEmpty {
                        ContentUnavailableView("Search games", image: "gamecontroller", description: Text("Search for games by name."))
                    } else {
                        ForEach(searched) { game in
                            Button {
                               
                            } label: {
                                Text(game.name)
                            }
                        }
                    }
                } else {
                    if searchVM.games.isEmpty {
                        ContentUnavailableView("No games", image: "gamecontroller", description: Text("There's no games with the name you introduced."))
                    } else {
                        ForEach(searchVM.games) { game in
                            HStack (spacing: 10) {
                                Button {
                                    gamesVM.selectedGame = game
                                    try? searchVM.saveGameSearch(game: game, context: context)
                                } label: {
                                    GameCover(game: game, width: 60, height: 60)
                                    if let namespace{
                                        Text(game.name)
                                            .font(.body)
                                            .matchedGeometryEffect(id: "\(game.id)-name", in: namespace)

                                    }
                                }
                                .buttonStyle(.plain)
                            }
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
    GameListView()
        .environment(GamesVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
}