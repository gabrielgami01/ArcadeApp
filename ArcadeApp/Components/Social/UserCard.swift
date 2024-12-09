import SwiftUI

struct UserCard: View {
    @Environment(SocialVM.self) private var socialVM
    
    let user: User?
    
    var body: some View {
        if let user {
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
                
                BadgesCard(badges: socialVM.featuredBadges) { badge in
                    BadgeCard(type: .display, badge: badge)
                } emptyBadge: { index in
                    BadgeCard(type: .empty)
                }

            }
            .task {
                await socialVM.getUserBadges()
            }
            .padding()
            .background(Color.card, in: .rect(cornerRadius: 10))
            .padding(.horizontal)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

#Preview {
    UserCard(user: .test)
        .environment(SocialVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
