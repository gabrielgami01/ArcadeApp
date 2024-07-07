import SwiftUI

struct SearchView: View {
    @Environment(GamesVM.self) private var gamesVM
    @State var searchVM = SearchVM()
    
    private let columns = Array(repeating: GridItem(spacing: 10), count: 2)
    
    var body: some View {
        @Bindable var bvm = searchVM
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    Section {
                        ForEach(gamesVM.consoles) { console in
                            NavigationLink(value: console){
                                MasterCard(master: console)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text("Browse by console")
                            .font(.title3)
                            .bold()
                        
                    }
                    Section {
                        ForEach(gamesVM.genres) { genre in
                            NavigationLink(value: genre){
                                MasterCard(master: genre)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text("Browse by genre")
                            .font(.title3)
                            .bold()
                        
                    }
                }
            }
            .navigationTitle("Search")
            .navigationDestination(for: Console.self, destination: { console in
                GamesView(master: console)
            })
            .navigationDestination(for: Genre.self, destination: { genre in
                GamesView(master: genre)
            })
            .searchable(text: $bvm.search, placement: .navigationBarDrawer(displayMode: .always)) {
                if !searchVM.games.isEmpty {
                    ForEach(searchVM.games) { game in
                        Text(game.name)
                    }
                } else if searchVM.search.isEmpty{
                    Text("Swift Data")
                } else {
                    Text("No hay")
                }
            }
            .onChange(of: searchVM.search, { oldValue, newValue in
                searchVM.searchGame(name: newValue)
            })
            .safeAreaPadding()
            .background(Color("backgroundColor").gradient)
        }
        
    }
}

#Preview {
    SearchView(searchVM: SearchVM(interactor: TestInteractor()))
        .environment(GamesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}



