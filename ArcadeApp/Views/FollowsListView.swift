import SwiftUI

struct FollowsListView: View {
    @Environment(SocialVM.self) private var socialVM
    @State private var selectedUser: User?
    
    let type: ProfilePage
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(type == .following ? socialVM.following : socialVM.followers) { user in
                    Button {
                        withAnimation {
                            selectedUser = user
                        }
                    } label: {
                        FollowsCell(user: user, type: type)
                    }
                    .buttonStyle(.plain)
                }
            }
            .disabled(selectedUser != nil)
        }
        .blur(radius: selectedUser != nil ? 10 : 0)
        .onTapGesture {
            if selectedUser != nil {
                withAnimation {
                    selectedUser = nil
                }
            }
        }
        .overlay {
            if let selectedUser {
                UserCard(isFollowed: type == .following, user: selectedUser)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    FollowsListView(type: .following)
        .environment(SocialVM(interactor: TestInteractor()))
        .padding()
        .background(Color.background)
        .preferredColorScheme(.dark)
}
