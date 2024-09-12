import SwiftUI

struct ContentView: View {
    @Environment(UserVM.self) private var userVM
    
    var body: some View {
        Group {
            if userVM.isLogged {
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
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(UserVM())
        .environment(SocialVM(interactor: TestInteractor()))
}
