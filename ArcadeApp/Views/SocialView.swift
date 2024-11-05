import SwiftUI

struct SocialView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SocialVM.self) private var socialVM
    
    @State private var selectedUser: User?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        ActiveSessionCell()
                        
                        ForEach(socialVM.followingSessions) { session in
                            if let user = socialVM.findFollowingByID(session.userID) {
                                Button {
                                    withAnimation {
                                        if user != userVM.activeUser {
                                            selectedUser = user
                                        }
                                    }
                                } label: {
                                    UserActiveSessionCell(user: user, game: session.game.name)
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
                            ForEach(socialVM.followers) { userConnection in
                                Button {
                                    withAnimation {
                                        if userConnection.user != userVM.activeUser {
                                            selectedUser = userConnection.user
                                        }
                                    }
                                } label: {
                                    NotificationCell(userConnection: userConnection)
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
            .disabled(selectedUser != nil)
            .blur(radius: selectedUser != nil ? 10 : 0)
        }
        .task {
            await socialVM.getFollowingActiveSessions()
        }
        .onTapGesture {
            if selectedUser != nil {
                withAnimation {
                    selectedUser = nil
                }
            }
        }
        .overlay {
            if let selectedUser {
                UserCard(user: selectedUser)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .headerToolbar(title: "Social")
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        SocialView()
            .environment(UserVM(repository: TestRepository()))
            .environment(SocialVM(repository: TestRepository()))
            .environment(BadgesVM(repository: TestRepository()))
            .environment(SessionVM(repository: TestRepository()))
            .preferredColorScheme(.dark)
    }
}

