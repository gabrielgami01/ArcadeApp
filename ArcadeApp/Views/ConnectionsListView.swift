import SwiftUI

struct ConnectionsListView: View {
    @Environment(SocialVM.self) private var socialVM
    
    let type: ConnectionOptions
    
    @State private var selectedUser: User?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(type == .following ? socialVM.following : socialVM.followers) { userFollows in
                    Button {
                        withAnimation {
                            selectedUser = userFollows.user
                        }
                    } label: {
                        ConnectionsCell(user: userFollows.user)
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
                UserCard(user: selectedUser)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    ConnectionsListView(type: .following)
        .environment(SocialVM(interactor: TestInteractor()))
        .padding(.horizontal)
        .background(Color.background)
        .preferredColorScheme(.dark)
}
