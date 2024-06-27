import SwiftUI

struct GamesListView: View {
    let master: Master
    
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
            await searchVM.getGamesByMaster(master: master)
        }
        .navigationTitle(master.name)
    }
}

#Preview {
    GamesListView(master: Console.test, searchVM: SearchVM(interactor: TestInteractor()))
}
