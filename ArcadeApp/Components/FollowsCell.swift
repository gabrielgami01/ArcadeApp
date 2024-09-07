import SwiftUI

struct FollowsCell: View {
    @Environment(SocialVM.self) private var socialVM
    
    let user: User
    let type: ProfilePage
    
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
            
            Group {
                if type == .following {
                    Button {
                        socialVM.unfollowUser(userID: user.id)
                    } label: {
                        Text("Following")
                    }
                } else {
                    if socialVM.isFollowed(userID: user.id) {
                        Button {
                            socialVM.unfollowUser(userID: user.id)
                        } label: {
                            Text("Following")
                        }
                    } else {
                        Button {
                            socialVM.followUser(userID: user.id)
                        } label: {
                            Text("Follow back")
                        }
                    }
                }
            }
            .font(.customBody)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.card, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    FollowsCell(user: .test, type: .following)
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
        .padding()
}
