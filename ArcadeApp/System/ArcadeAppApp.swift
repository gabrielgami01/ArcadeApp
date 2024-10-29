import SwiftUI
import SwiftData

@main
struct ArcadeAppApp: App {
    @State private var network = NetworkStatus()
    @State private var userVM = UserVM()
    @State private var gamesVM = GamesVM()
    @State private var detailsVM = GameDetailsVM()
    @State private var gameSessionVM = SessionVM()
    @State private var badgesVM = BadgesVM()
    @State private var socialVM = SocialVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userVM)
                .environment(gamesVM)
                .environment(detailsVM)
                .environment(gameSessionVM)
                .environment(badgesVM)
                .environment(socialVM)
                .unavailableNetwork(status: network.status)
        }
        .modelContainer(for: GameModel.self)
        
    }
}
