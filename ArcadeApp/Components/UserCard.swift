import SwiftUI

struct UserCard: View {
    @Environment(ChallengesVM.self) private var challengesVM
    
    let user: User
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 10) {
                UserAvatarImage(imageData: user.avatarImage, size: 75)
                
                VStack(alignment: .leading) {
                    Text(user.username)
                        .font(.customTitle3)
                    
                    if let about = user.biography {
                        Text(about)
                            .font(.customFootnote)
                    }
                }
                
                Spacer()
                
                ConnectionsButton(user: user)
            }
            
            HStack(spacing: 0) {
                ForEach(Array(challengesVM.emblems.enumerated()), id: \.element.id) { index, emblem in
                    EmblemCard(emblem: emblem)
                    if index != challengesVM.emblems.count - 1 || challengesVM.emblems.count < 3 {
                        Spacer()
                    }
                }
                
                ForEach(0..<max(0, 3 - challengesVM.emblems.count), id: \.self) { index in
                    EmblemCard(emblem: nil)
                    if index != max(0, 3 - challengesVM.emblems.count) - 1 {
                        Spacer()
                    }
                }
            }
        }
        .task {
            await challengesVM.getUserEmblems(id: user.id)
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    UserCard(user: .test)
        .environment(ChallengesVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
