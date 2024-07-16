import SwiftUI

struct GameListView: View {
    let namespace: Namespace.ID
    @Environment(GamesVM.self) private var gamesVM
    @State var searchVM = SearchVM()
    
    var body: some View {
        @Bindable var bvm = searchVM
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    // ConsoleTags
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 10) {
                            ForEach(Console.allCases) { console in
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
                                    GameCard(game: game, namespace: namespace)
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
                if !searchVM.games.isEmpty {
                    ForEach(searchVM.games) { game in
                        Text(game.name)
                    }
                } else if searchVM.search.isEmpty{
                    Text("Swift Data")
                } else {
                    Text("No hay")
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
    GameListView(namespace: Namespace().wrappedValue)
        .environment(GamesVM(interactor: TestInteractor()))
}
