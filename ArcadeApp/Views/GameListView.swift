import SwiftUI

struct GameListView: View {
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var animationGame: Game?
    @State private var showSearchable = false
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        @Bindable var gamesBVM = gamesVM
        
        ScrollView {
            VStack(spacing: 15) {
                ScrollPicker(selected: $gamesBVM.activeConsole)
                
                LazyVStack(spacing: 20) {
                    ForEach(gamesVM.games) { game in
                        if game.id != gamesVM.selectedGame?.id {
                            GameCell(game: game, animation: $animationGame)
                                .scrollTransition(.animated, axis: .vertical) { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.4)
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                                }
                                .onAppear {
                                    gamesVM.isLastItem(game)
                                }
                        } else {
                            Color.clear
                                .frame(height: 210)
                        }
                    }
                }
                
            }
            .namespace(showSearchable ? nil : namespace)
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
    }
}

#Preview {
    GameListView()
        .environment(GamesVM(repository: TestRepository()))
        .environment(GameDetailsVM(repository: TestRepository()))
        .environment(UserVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
        .environment(BadgesVM(repository: TestRepository()))
        .environment(SessionVM(repository: TestRepository()))
        .swiftDataPreview
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}

