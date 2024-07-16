import SwiftUI

struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    
    var body: some View {
        ScrollView {
            Button {
                userVM.logout()
            } label: {
                Text("Logout")
            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(UserVM())
}
