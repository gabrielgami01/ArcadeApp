import SwiftUI

struct ContentView: View {
    @Environment(UserVM.self) private var userVM
    
    var body: some View {
        Group {
            if let _ = userVM.activeUser {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environment(UserVM())
        .environment(GamesVM(repository: TestRepository()))
        .environment(GameDetailsVM(repository: TestRepository()))
        .environment(ChallengesVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
}
