import SwiftUI

struct ConnectionsListView: View {
    @Environment(SocialVM.self) private var socialVM
    
    let type: ConnectionOptions
    
    var connections: [UserConnections] {
        switch type {
            case .following: socialVM.following
            case .followers: socialVM.followers
        }
    }
    
    var body: some View {
        if !connections.isEmpty {
            LazyVStack(spacing: 15) {
                ForEach(connections) { connection in
                    Button {
                        withAnimation {
                            socialVM.selectedUser = connection.user
                        }
                    } label: {
                        ConnectionsCell(user: connection.user)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        } else {
            CustomUnavailableView(title: "No \(type.rawValue)", image: "person.2.fill",
                                  description: "You haven't any \(type.rawValue) yet.")
        }
    }
}

#Preview {
    ConnectionsListView(type: .following)
        .environment(SocialVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
