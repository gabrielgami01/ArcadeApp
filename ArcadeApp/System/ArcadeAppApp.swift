import SwiftUI
import SwiftData

@main
struct ArcadeAppApp: App {
    @State private var userVM = UserVM()
    @State private var gamesVM = GamesVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userVM)
                .environment(gamesVM)
        }
        .modelContainer(for: GameModel.self)
        
    }
}
