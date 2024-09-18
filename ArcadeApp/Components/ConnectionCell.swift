import SwiftUI

struct FollowsCell: View {
    @Environment(SocialVM.self) private var socialVM
    
    let user: User
    let type: ConnectionType
    
    var body: some View {
        HStack {
            UserAvatarImage(imageData: user.avatarImage, size: 60)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.customTitle3)
                Text(user.fullName)
                    .font(.customFootnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    FollowsCell(user: .test, type: .following)
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
        .padding()
}

struct ConnectionsButton: View {
    
}
