import SwiftUI

struct HomeView: View {
    @Environment(UserVM.self) private var userVM
    var body: some View {
        VStack {
            Text("Home")
            Button {
                userVM.logout()
            } label: {
                Text("Logout")
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(UserVM())
}
