import SwiftUI

@main
struct ArcadeAppApp: App {
    @State private var userVM = UserVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userVM)
        }
    }
}
