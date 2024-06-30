import SwiftUI

struct ContentView: View {
    @Environment(UserVM.self) private var loginVM
    
    var body: some View {
        if loginVM.isLogged {
            MainTabView()
        } else {
            LoginView()
        }
        
    }
}

#Preview {
    ContentView()
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
}
