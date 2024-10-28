import SwiftUI

struct UserCard: View {
    
    let user: User
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 10) {
                UserAvatarImage(imageData: user.avatarImage, size: 75)
                
                VStack(alignment: .leading) {
                    Text(user.username)
                        .font(.customTitle3)
                    
                    if let about = user.about {
                        Text(about)
                            .font(.customFootnote)
                    }
                }
                
                Spacer()
                
                ConnectionsButton(user: user)
            }
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 10))
        .padding(.horizontal)
    }
}

#Preview {
    UserCard(user: .test)
        .environment(SocialVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
