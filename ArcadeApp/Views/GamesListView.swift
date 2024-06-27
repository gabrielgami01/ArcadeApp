import SwiftUI

struct GamesListView: View {
    let item: Master
    
    @State var searchVM: SearchVM
    
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(searchVM.games) { game in
                    Text(game.name)
                }
            }
        }
        .task {
            await searchVM.getGamesByGenreConsole(item: item)
        }
    }
}

#Preview {
    GamesListView(item: Console.test, searchVM: SearchVM(interactor: TestInteractor()))
}
