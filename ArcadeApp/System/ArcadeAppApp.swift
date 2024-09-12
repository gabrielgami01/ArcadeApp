import SwiftUI
import SwiftData

@main
struct ArcadeAppApp: App {
    @State private var userVM = UserVM()
    @State private var gamesVM = GamesVM()
    @State private var detailsVM = GameDetailsVM()
    @State private var socialVM = SocialVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userVM)
                .environment(gamesVM)
                .environment(detailsVM)
                .environment(socialVM)
        }
        .modelContainer(for: GameModel.self)
        
    }
}
