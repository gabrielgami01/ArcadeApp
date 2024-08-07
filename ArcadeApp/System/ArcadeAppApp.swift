import SwiftUI
import SwiftData

@main
struct ArcadeAppApp: App {
    @State private var userVM = UserVM()
    @State private var gamesVM = GamesVM()
    @State private var searchVM = SearchVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userVM)
                .environment(gamesVM)
                .environment(searchVM)
        }
        .modelContainer(for: GameModel.self)
        
    }
}
