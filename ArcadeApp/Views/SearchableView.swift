import SwiftUI
import SwiftData
import Combine

struct SearchableView: View {
    @Environment(\.modelContext) private var context
    @Environment(GamesVM.self) private var gamesVM
    @State private var searchVM = SearchVM()
    
    @Binding var show: Bool
    
    @FocusState private var focus: Bool 
    
    @Query(sort: [SortDescriptor(\GameModel.added, order: .reverse)]) private var recentSearchs: [GameModel]
    
    var body: some View {
        @Bindable var searchBVM = searchVM
        
        ScrollView {
            VStack(spacing: 20) {
                HStack(alignment: .firstTextBaseline) {
                    CustomTextField(text: $searchBVM.inputText, label: "Search", type: .search)
                        .focused($focus)

                    Button {
                        show = false
                        searchVM.inputText.removeAll()
                    } label: {
                        Text("Cancel")
                            .font(.customTitle3)
                    }
                }
                
                if searchVM.searchText.isEmpty {
                    if !recentSearchs.isEmpty {
                        HStack {
                            Text("Recent searches")
                                .font(.customTitle3)
                            
                            Spacer()
                            
                            Button {
                                try? searchVM.deleteGameSearch(context: context)
                            } label: {
                                Text("Clear all")
                                    .font(.customHeadline)
                            }
                        }
                
                        LazyVStack {
                            ForEach(recentSearchs) { gameModel in
                                if gameModel.id != gamesVM.selectedGame?.id {
                                    HStack(alignment: .firstTextBaseline) {
                                        Button {
                                            withAnimation {
                                                gamesVM.selectedGame = gameModel.toGame
                                            }
                                            
                                            focus = false
                                        } label: {
                                            SearchCell(game: gameModel.toGame)
                                        }
                                        
                                        Button {
                                            try? searchVM.deleteGameSearch(game: gameModel.toGame, context: context)
                                        } label: {
                                            Text("X")
                                                .font(.customTitle2)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    Color.clear
                                        .frame(height: 60)
                                }
                            }
                        }
                    } else {
                        CustomUnavailableView(title: "Search games", image: "gamecontroller",
                                              description: "Search for games by name.")
                    }
                } else {
                    if !searchVM.games.isEmpty {
                        LazyVStack {
                            ForEach(searchVM.games) { game in
                                if game.id != gamesVM.selectedGame?.id {
                                    Button {
                                        withAnimation {
                                            gamesVM.selectedGame = game
                                        }
                                        focus = false
                                        try? searchVM.saveGameSearch(game: game, context: context)
                                    } label: {
                                        SearchCell(game: game)
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    Color.clear
                                        .frame(height: 60)
                                }
                            }
                        }
                    } else {
                        CustomUnavailableView(title: "No results for '\(searchVM.searchText)'", image: "magnifyingglass",
                                              description: "Check the spelling or try a new search.")
                    }
                }
            }
        }
        .onAppear {
            focus = true
        }
        .onDisappear {
            focus = false
        }
        .showAlert(show: $searchBVM.showError, text: searchVM.errorMsg)
        .padding(.horizontal)
    }
}

#Preview {
    SearchableView(show: .constant(true))
        .environment(GamesVM(interactor: TestInteractor()))
        .swiftDataPreview
        .preferredColorScheme(.dark)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
        .namespace(Namespace().wrappedValue)
}
