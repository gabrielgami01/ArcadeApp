import SwiftUI

struct ContentView: View {
    @Environment(UserVM.self) private var loginVM
    
    var body: some View {
        Group {
            if loginVM.isLogged {
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
