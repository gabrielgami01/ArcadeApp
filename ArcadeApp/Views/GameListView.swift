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
                Group {
                    Button {
                        showSearchable = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName:"magnifyingglass")
                                .font(.customBody)
                            Text("Search")
                                .font(.customBody)
                            Spacer()
                        }
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(TextFieldStyleButton())
                    
                    ScrollSelector(selected: $gamesBVM.activeConsole)
                }
                .scrollTransition(.animated, axis: .vertical) { content, phase in
                    content
                        .opacity(phase.isIdentity ? 1.0 : 0.4)
                }
                
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
            .opacity(!showSearchable && gamesVM.selectedGame == nil ? 1.0 : 0.0 )
            .namespace(showSearchable ? nil : namespace)
        }
        .padding(.top)
        .onChange(of: gamesVM.selectedGame) { oldValue, newValue in
            if newValue == nil {
                withAnimation(.default.delay(0.4)) {
                    animationGame = newValue
                }
            }
        }
        .overlay {
            ZStack {
                GameDetailsView(game: gamesVM.selectedGame)
                    .zIndex(1)
                if showSearchable {
                    SearchableView(show: $showSearchable)
                        .opacity(gamesVM.selectedGame == nil ? 1.0 : 0.0)
                }
            }
        }
        .showAlert(show: $gamesBVM.showError, text: gamesVM.errorMsg)
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
        .namespace(namespace)
    }
}

#Preview {
    GameListView()
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(GameDetailsVM(interactor: TestInteractor()))
        .environment(UserVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
        .swiftDataPreview
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}

