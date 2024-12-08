import SwiftUI

struct ConnectionsList: View {
    let connections: [UserConnections]
    let type: ConnectionOptions
    let onUserSelect: (User) -> Void
    
    var body: some View {
        if !connections.isEmpty {
            LazyVStack(spacing: 15) {
                ForEach(connections) { connection in
                    Button {
                        onUserSelect(connection.user)
                    } label: {
                        ConnectionsCell(user: connection.user)
                    }
                    .buttonStyle(.plain)
                }
            }
        } else {
            CustomUnavailableView(title: "No \(type.rawValue)", image: "person.2.fill",
                                  description: "You haven't any \(type.rawValue) yet.")
        }
    }
}

#Preview {
    ConnectionsList(connections: [.test, .test2, .test3], type: .following) { _ in }
        .environment(SocialVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
