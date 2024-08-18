import SwiftUI

struct GameListView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(SearchVM.self) private var searchVM    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        @Bindable var gamesBVM = gamesVM
        @Bindable var searchBVM = searchVM
        
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    searchVM.showSearch.toggle()
                } label: {
                    HStack(spacing: 10){
                        Image(systemName:"magnifyingglass")
                            .font(.customBody) 
                        Text("Search")
                            .font(.customBody)
                        Spacer()
                    }
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(TextFieldButton())
                
                ScrollSelector(activeSelection: $gamesBVM.activeConsole) { $0.rawValue }
                
                LazyVStack(spacing: 20) {
                    ForEach(gamesVM.games) { game in
                        Button {
                            gamesVM.selectedGame = game
                        } label: {
                            GameCell(game: game, selectedGame: $gamesBVM.selectedGame)
                                .padding(.leading)
                        }
                        .buttonStyle(.plain)
                        .scrollTransition(.animated, axis: .vertical) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.4)
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                        }
                        .onAppear {
                            gamesVM.isLastItem(game)
                        }
                    }
                }
                .padding()
            }
        }
        .onChange(of: searchVM.search) { oldValue, newValue in
            searchVM.searchGame(name: newValue)
        }
        .onChange(of: gamesVM.activeConsole) { oldValue, newValue in
            gamesVM.getGames(console: newValue)
        }
        .animation(.easeInOut, value: gamesVM.games)
        .scrollIndicators(.hidden)
        .background(Color.background)
    }
}

#Preview {
    GameListView()
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(SearchVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
}


