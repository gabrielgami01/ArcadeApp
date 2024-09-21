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
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(GameDetailsVM(interactor: TestInteractor()))
        .environment(ChallengesVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
}
