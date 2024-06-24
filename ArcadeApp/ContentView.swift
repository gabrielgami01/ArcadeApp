import SwiftUI

struct ContentView: View {
    @Environment(LoginVM.self) private var loginVM
    
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
        .environment(LoginVM())
    
}
