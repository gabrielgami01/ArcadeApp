import SwiftUI
import SwiftData

@main
struct ArcadeAppApp: App {
    @State private var network = NetworkStatus()
    @State private var userVM = UserVM()
    @State private var gamesVM = GamesVM()
    @State private var gameSessionVM = SessionVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userVM)
                .environment(gamesVM)
                .environment(gameSessionVM)
                .unavailableNetwork(status: network.status)
        }
        .modelContainer(for: GameModel.self)
        
    }
}
