import SwiftUI

struct NotificationCell: View {
    let connection: UserConnections
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                UserAvatarImage(imageData: connection.user.avatarImage, size: 60)
                
                VStack(alignment: .leading) {
                    Text("\(connection.user.username) started following you.")
                        .font(.customBody)
                    Text(connection.createdAt.timeDifference())
                        .font(.customFootnote)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                ConnectionsButton(user: connection.user)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
        }
        .background(Color.background)
    }
}

#Preview {
    NotificationCell(connection: .test)
}
