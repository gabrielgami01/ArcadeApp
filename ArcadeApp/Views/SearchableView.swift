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
            VStack(spacing: 20) {
                HStack(alignment: .firstTextBaseline) {
                    CustomTextField(text: $searchBVM.searchText, label: "Search", type: .search)
                        .focused($focus)
                    
                    Button {
                        show = false
                        searchVM.searchText.removeAll()
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
                                SearchCell(searchVM: searchVM, game: gameModel.toGame, isRecent: true)
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
                                SearchCell(searchVM: searchVM, game: game)
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
        .background(Color.background)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    SearchableView(show: .constant(true))
        .environment(GamesVM(interactor: TestInteractor()))
        .swiftDataPreview
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}
