import SwiftUI

struct SearchView: View {
    @Environment(SearchVM.self) private var searchVM
    
    private let columns = Array(repeating: GridItem(spacing: 10), count: 2)
    
    var body: some View {
        @Bindable var bvm = searchVM
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    Section {
                        ForEach(searchVM.consoles) { console in                            
                            NavigationLink(value: console){
                                ConsoleGenreCard(item: console)
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
                                ConsoleGenreCard(item: genre)
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
                GamesListView(item: console)
            })
            .navigationDestination(for: Genre.self, destination: { genre in
                GamesListView(item: genre)
            })
            .searchable(text: $bvm.search, placement: .navigationBarDrawer(displayMode: .always)) {
                //SwiftData RecentSearchs
            }
            .safeAreaPadding()
        }
    }
}

#Preview {
    SearchView()
        .environment(SearchVM(interactor: SearchInteractorTest()))
}

struct ConsoleGenreCard: View {
    let item: GenreConsole
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.fill)
            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            .overlay(alignment: .topLeading) {
                Text(item.name)
                    .font(.callout)
                    .bold()
                    .padding()
            }
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55)
                    .padding()
            }
    }
}
