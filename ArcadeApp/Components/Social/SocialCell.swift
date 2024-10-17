import SwiftUI

struct SocialCell: View {
    @Environment(SocialVM.self) private var socialVM
    
    let userConnection: UserConnections
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                UserAvatarImage(imageData: userConnection.user.avatarImage, size: 60)
                
                VStack(alignment: .leading) {
                    Text("\(userConnection.user.username) started following you.")
                        .font(.customBody)
                    Text(userConnection.createdAt.timeDifference())
                        .font(.customFootnote)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                ConnectionsButton(user: userConnection.user)
            }
            .frame(maxWidth: .infinity)
            Divider()
        }
        .background(Color.background)
    }
}

#Preview {
    SocialCell(userConnection: .test)
        .environment(SocialVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        
}
