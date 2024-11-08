import SwiftUI

struct UserCard: View {
    @Environment(BadgesVM.self) private var badgesVM
    
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
            
            BadgesCard(badges: badgesVM.userBadges) { badge in
                BadgeCard(type: .display, badge: badge)
            } emptyBadge: { index in
                BadgeCard(type: .empty)
            }

        }
        .task {
            await badgesVM.getFeaturedBadges(id: user.id)
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 10))
        .padding(.horizontal)
    }
}

#Preview {
    UserCard(user: .test)
        .environment(SocialVM(repository: TestRepository()))
        .environment(BadgesVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
