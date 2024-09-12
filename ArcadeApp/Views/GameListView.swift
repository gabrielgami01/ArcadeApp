import SwiftUI

struct GameListView: View {
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var animationGame: Game?
    @State private var showSearchable = false
    
    @Namespace private var namespace
    
    
    var body: some View {
        @Bindable var gamesBVM = gamesVM
        
        ScrollView {
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    ScrollSelector(activeSelection: $gamesBVM.activeConsole) { $0.rawValue }
                    
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
                    .animation(.none, value: gamesVM.activeConsole)
                } header: {
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
                    .stickyHeader()
                }
            }
            .opacity(!showSearchable && gamesVM.selectedGame == nil ? 1.0 : 0.0 )
            .namespace(showSearchable ? nil : namespace)
        }
        .ignoresSafeArea(edges: .top)
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
                }
            }
        }
        .showAlert(show: $gamesBVM.showError, text: gamesVM.errorMsg)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
        .namespace(namespace)
    }
}

#Preview {
    GameListView()
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(UserVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
        .swiftDataPreview
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}

