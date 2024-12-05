import SwiftUI

struct GameListView: View {
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var animationGame: Game?
    @State private var showSearchable = false
    
    @Namespace private var namespace
    
    var body: some View {
        @Bindable var gamesBVM = gamesVM
        
        ScrollView {
            VStack(spacing: 15) {
                ScrollPicker(selected: $gamesBVM.activeConsole)
                
                if !gamesVM.games.isEmpty {
                    LazyVStack(spacing: 20) {
                        ForEach(gamesVM.games) { game in
                            Button {
                                withAnimation {
                                    animationGame = game
                                } completion: {
                                    withAnimation {
                                        gamesVM.selectedGame = game
                                    }
                                }
                            } label: {
                                GameCell(game: game, animation: animationGame)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } else {
                    CustomUnavailableView(title: "No games found", image: "exclamationmark.triangle",
                                          description: "There isn't any game by the moment.")
                }
            }
            .namespace(showSearchable ? nil : namespace)
        }
        .refreshable {
            Task {
                await gamesVM.getGames()
            }
        }
        .onChange(of: gamesVM.selectedGame) { oldValue, newValue in
            if newValue == nil {
                withAnimation(.default.delay(0.4)) {
                    animationGame = newValue
                }
            }
        }
        .safeAreaInset(edge: .top) {
            Button {
                showSearchable = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName:"magnifyingglass")
                    
                    Text("Search")
                    
                    Spacer()
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(TextFieldStyleButton())
        }
        .tabBarInset()
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
        .opacity(!showSearchable && gamesVM.selectedGame == nil ? 1.0 : 0.0)
        .overlay {
            SearchableView(show: $showSearchable)
                .opacity(showSearchable && gamesVM.selectedGame == nil ? 1.0 : 0.0)
        }
        .overlay {
            GameDetailsView(game: gamesVM.selectedGame)
        }
        .namespace(namespace)
        .errorAlert(show: $gamesBVM.showError)
    }
}

#Preview {
    GameListView()
        .environment(GamesVM(repository: TestRepository()))
        .environment(UserVM(repository: TestRepository()))
        .environment(SessionVM(repository: TestRepository()))
        .swiftDataPreview
        .preferredColorScheme(.dark)
}

