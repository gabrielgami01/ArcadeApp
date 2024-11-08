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
            
            HStack(spacing: 0) {
                ForEach(Array(badgesVM.userBadges.enumerated()), id: \.element.id) { index, badge in
                    BadgeCard(type: .display, badge: badge)
                    
                    if index != badgesVM.userBadges.count - 1 || badgesVM.userBadges.count < 3 {
                        Spacer()
                    }
                }
                
                ForEach(0..<max(0, 3 - badgesVM.userBadges.count), id: \.self) { index in
                    BadgeCard(type: .empty)
                    
                    if index != max(0, 3 - badgesVM.userBadges.count) - 1 {
                        Spacer()
                    }
                }
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
