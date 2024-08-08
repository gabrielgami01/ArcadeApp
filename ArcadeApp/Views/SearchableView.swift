import SwiftUI
import SwiftData

struct SearchableView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(SearchVM.self) private var searchVM
    @Environment(\.modelContext) private var context
    @FocusState private var focus: Bool
    
    @Query(sort: [SortDescriptor(\GameModel.added, order: .reverse)]) private var recentSearchs: [GameModel]
    
    var body: some View {
        @Bindable var bvm = searchVM
        
        ScrollView {
            VStack(spacing: 0) {
                HStack(alignment: .firstTextBaseline) {
                    CustomTextField(value: $bvm.search, isError: .constant(false), label: "Search", type: .search)
                        .focused($focus)
                    Button {
                        searchVM.showSearch.toggle()
                        searchVM.search.removeAll()
                    } label: {
                        Text("Cancel")
                            .font(.customTitle3)
                    }
                }
                .padding(.top, 5)
                
                Group {
                    if searchVM.search.isEmpty {
                        if recentSearchs.isEmpty {
                            CustomUnavailableView(title: "Search games", image: "gamecontroller", description: "Search for games by name.")
                        } else {
                            LazyVStack(alignment: .listRowSeparatorLeading) {
                                Text("Recent searches")
                                    .font(.customTitle3)
                                ForEach(recentSearchs) { gameModel in
                                    let game = gameModel.toGame
                                    SearchCell(game: game, isRecent: true)
                                }
                            }
                        }
                    } else {
                        if searchVM.games.isEmpty {
                            CustomUnavailableView(title: "No results for '\(searchVM.search)'", image: "magnifyingglass", description: "Check the spelling or try a new search.")
                        } else {
                            LazyVStack(alignment: .leading) {
                                ForEach(searchVM.games) { game in
                                    SearchCell(game: game, isRecent: false)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: searchVM.showSearch) { oldValue, newValue in
            focus = newValue == true ? true :  false
        }
        .onChange(of: gamesVM.selectedGame) {
            focus = false
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
    }
}

#Preview {
    SearchableView()
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(SearchVM(interactor: TestInteractor()))
}
