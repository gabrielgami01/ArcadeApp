import SwiftUI

struct SocialView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SocialVM.self) private var socialVM
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
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
        .padding(.horizontal)
        .background(Color.background)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    SocialView()
        .environment(UserVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
