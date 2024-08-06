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
        .background(Color.backgroundColor)
    }
}

#Preview {
    ProfileView()
        .environment(UserVM())
}
