import SwiftUI

struct HomeView: View {
    @Environment(LoginVM.self) private var loginVM
    var body: some View {
        VStack {
            Text("Home")
            Button {
                loginVM.logout()
            } label: {
                Text("Logout")
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(LoginVM())
}
