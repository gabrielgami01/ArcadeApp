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
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
}
