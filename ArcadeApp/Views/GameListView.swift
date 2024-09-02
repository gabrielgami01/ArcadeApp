import SwiftUI

struct GameListView: View {
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var animationGame: Game?
    @State private var showSearchable = false
    
    @Namespace private var namespace
    
    var body: some View {
        @Bindable var gamesBVM = gamesVM
        
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    showSearchable.toggle()
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
                .buttonStyle(TextFieldStyleButton())
                
                ScrollSelector(activeSelection: $gamesBVM.activeConsole) { $0.rawValue }
                
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
                .padding(.horizontal)
            }
        }
        .onChange(of: gamesVM.activeConsole) { _, _ in
            gamesVM.getGames()
        }
        .onChange(of: gamesVM.selectedGame) { oldValue, newValue in
            if newValue == nil {
                withAnimation(.default.delay(0.4)) {
                    animationGame = newValue
                }
            }
        }
        .showAlert(show: $gamesBVM.showError, text: gamesVM.errorMsg)
        .overlay {
            ZStack {
                GameDetailsView(game: gamesVM.selectedGame)
                    .zIndex(1)
                SearchableView(show: $showSearchable)
                    .opacity(showSearchable ? 1.0 : 0.0)
            }
        }
        .namespace(namespace)
        .background(Color.background)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    GameListView()
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(SearchVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}


