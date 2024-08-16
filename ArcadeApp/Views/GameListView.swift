import SwiftUI

struct GameListView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(SearchVM.self) private var searchVM    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        @Bindable var gamesBVM = gamesVM
        @Bindable var searchBVM = searchVM
        
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
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
                                        .font(.customCaption2)
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
                            GameCell(game: game, selectedGame: $gamesBVM.selectedGame)
                                .padding(.leading)
                        }
                        .buttonStyle(.plain)
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

