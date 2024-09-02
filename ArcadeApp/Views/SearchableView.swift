import SwiftUI
import SwiftData

struct SearchableView: View {
    @Environment(\.modelContext) private var context
    @State private var searchVM = SearchVM()
    @Binding var show: Bool
    
    @FocusState private var focus: Bool 
    
    @Query(sort: [SortDescriptor(\GameModel.added, order: .reverse)]) private var recentSearchs: [GameModel]
    
    var body: some View {
        @Bindable var searchBVM = searchVM
        
        ScrollView {
            VStack(spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    CustomTextField(text: $searchBVM.search, label: "Search", type: .search)
                        .focused($focus)
                    Button {
                        show.toggle()
                        searchVM.search.removeAll()
                    } label: {
                        Text("Cancel")
                            .font(.customTitle3)
                    }
                }
                
                if searchVM.search.isEmpty {
                    if !recentSearchs.isEmpty {
                        LazyVStack(alignment: .listRowSeparatorLeading) {
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
                            ForEach(recentSearchs) { gameModel in
                                SearchCell(game: gameModel.toGame, isRecent: true)
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
                                SearchCell(game: game)
                            }
                        }
                    } else {
                        CustomUnavailableView(title: "No results for '\(searchVM.search)'", image: "magnifyingglass",
                                              description: "Check the spelling or try a new search.")
                    }
                }
            }
        }
        .onAppear {
            focus.toggle()
        }
        .onDisappear {
            focus.toggle()
        }
        .onChange(of: searchVM.search) { _, _ in
            searchVM.searchGame()
        }
        .padding(.horizontal)
        .background(Color.background)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    SearchableView(show: .constant(true))
        .environment(SearchVM(interactor: TestInteractor()))
        .environment(GamesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
