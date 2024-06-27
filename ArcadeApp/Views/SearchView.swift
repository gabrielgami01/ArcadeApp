import SwiftUI

struct SearchView: View {
    @State var searchVM = SearchVM(interactor: TestInteractor())
    
    private let columns = Array(repeating: GridItem(spacing: 10), count: 2)
    
    var body: some View {
        @Bindable var bvm = searchVM
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    Section {
                        ForEach(searchVM.consoles) { console in                            
                            NavigationLink(value: console){
                                MasterCard(master: console)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text("Browse by console")
                            .font(.headline)
                            .bold()
                        
                    }
                    Section {
                        ForEach(searchVM.genres) { genre in
                            NavigationLink(value: genre){
                                MasterCard(master: genre)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text("Browse by genre")
                            .font(.headline)
                            .bold()
                        
                    }
                }
            }
            .navigationTitle("Search")
            .navigationDestination(for: Console.self, destination: { console in
                GamesListView(master: console, searchVM: searchVM)
            })
            .navigationDestination(for: Genre.self, destination: { genre in
                GamesListView(master: genre, searchVM: searchVM)
            })
            .searchable(text: $bvm.search, placement: .navigationBarDrawer(displayMode: .always)) {
                //SwiftData RecentSearchs
            }
            .safeAreaPadding()
        }
    }
}

#Preview {
    SearchView(searchVM: SearchVM(interactor: TestInteractor()))
}


