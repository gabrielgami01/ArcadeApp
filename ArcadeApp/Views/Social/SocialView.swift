import SwiftUI

struct SocialView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SocialVM.self) private var socialVM
    @Environment(SessionVM.self) private var sessionVM
    
    var body: some View {
        @Bindable var socialBVM = socialVM
        
        ScrollView {
            VStack(spacing: 15) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        if let activeUser = userVM.activeUser {
                            VStack {
                                UserAvatarImage(imageData: activeUser.avatarImage, size: 80)
                                    .overlay {
                                        Group {
                                            if let activeSession = sessionVM.activeSession {
                                                Text(activeSession.game.name)
                                                    .font(.customFootnote)
                                                    .multilineTextAlignment(.center)
                                                
                                            } else {
                                                Text("Offline")
                                                    .font(.customFootnote)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                        .frame(width: 70, height: 30)
                                        .padding(5)
                                        .background(Color.card, in: RoundedRectangle(cornerRadius: 20))
                                        .offset(y: -20)
                                    }
                                
                                Text("Your session")
                                    .font(.customCallout)
                            }
                        }
                        
                        ForEach(socialVM.followingSessions) { session in
                            if let user = socialVM.findFollowingByID(session.userID) {
                                Button {
                                    if user.id != userVM.activeUser?.id {
                                        withAnimation {
                                            socialVM.selectedUser = user
                                        }
                                    }
                                    
                                } label: {
                                    ConnectionSessionCell(user: user, game: session.game.name)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .safeAreaPadding(.horizontal)
                }
                .padding(.top, 5)
                
                
                VStack(alignment: .leading) {
                    Text("Notifications")
                        .font(.customTitle3)
                    
                    if !socialVM.followers.isEmpty {
                        LazyVStack(spacing: 15) {
                            ForEach(socialVM.followers) { connection in
                                Button {
                                    if connection.user.id != userVM.activeUser?.id {
                                        withAnimation {
                                            socialVM.selectedUser = connection.user
                                        }
                                    }
                                } label: {
                                    NotificationCell(connection: connection)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    } else {
                        CustomUnavailableView(title: "No notifications", image: "bell.fill",
                                              description: "You haven't any notification yet.")
                    }
                }
                .padding(.horizontal)
            }
        }
        .task {
            await socialVM.getFollowingActiveSessions()
        }
        .tabBarInset()
        .headerToolbar(title: "Social")
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
        .errorAlert(show: $socialBVM.showError)
    }
}

#Preview {
    NavigationStack {
        SocialView()
            .environment(UserVM(repository: TestRepository()))
            .environment(SocialVM(repository: TestRepository()))
            .environment(SessionVM(repository: TestRepository()))
            .preferredColorScheme(.dark)
    }
}
