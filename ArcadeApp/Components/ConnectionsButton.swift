import SwiftUI

struct ConnectionsButton: View {
    @Environment(SocialVM.self) private var socialVM
    
    let user: User
    
    var body: some View {
        Group {
            if socialVM.isFollowed(userID: user.id) {
                Button {
                    Task {
                        if await socialVM.unfollowUserAPI(id: user.id) {
                            socialVM.unfollowUser(id: user.id)
                        }
                    }
                } label: {
                    Text("Following")
                }
            } else {
                Button {
                    Task {
                        if await socialVM.followUserAPI(id: user.id) {
                            let userConnections = UserConnections(id: UUID(), user: user, createdAt: .now)
                            socialVM.followUser(userConnections)
                        }
                    }
                } label: {
                    Text("Follow")
                }
            }
        }
        .buttonStyle(.borderedProminent)
        .font(.customBody)
    }
}

#Preview {
    ConnectionsButton(user: .test)
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
