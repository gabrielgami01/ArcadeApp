import SwiftUI

struct SocialView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SocialVM.self) private var socialVM
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(socialVM.followers) { userFollows in
                    VStack(alignment: .leading) {
                        HStack {
                            UserAvatarImage(imageData: userFollows.user.avatarImage, size: 60)
                            
                            VStack(alignment: .leading) {
                                Text("\(userFollows.user.username) started following you.")
                                    .font(.customBody)
                                Text(userFollows.createdAt.timeDifference())
                                    .font(.customFootnote)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Group {
                                if socialVM.isFollowed(userID: userFollows.user.id) {
                                    Button {
                                        socialVM.unfollowUser(userID: userFollows.user.id)
                                    } label: {
                                        Text("Following")
                                    }
                                } else {
                                    Button {
                                        socialVM.followUser(userID: userFollows.user.id)
                                    } label: {
                                        Text("Follow back")
                                    }
                                }
                            }
                            .font(.customBody)
                            .buttonStyle(.borderedProminent)
                        }
                        
                        Divider()
                    }
                }
            }
        }
        .headerToolbar(title: "Social") { dismiss() }
        .padding(.horizontal)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        SocialView()
            .environment(UserVM(interactor: TestInteractor()))
            .environment(SocialVM(interactor: TestInteractor()))
            .preferredColorScheme(.dark)
    }
}
