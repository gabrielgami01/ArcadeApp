import SwiftUI

struct SocialView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SocialVM.self) private var socialVM
    
    @State private var selectedUser: User?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(socialVM.followers) { userConnection in
                    Button {
                        withAnimation {
                            if userConnection.user != userVM.activeUser {
                                selectedUser = userConnection.user
                            }
                        }
                    } label: {
                        SocialCell(userConnection: userConnection)
                    }
                    .buttonStyle(.plain)
                }
            }
            .disabled(selectedUser != nil)
            .blur(radius: selectedUser != nil ? 10 : 0)
            .padding(.horizontal)
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
            .environment(UserVM(interactor: TestInteractor()))
            .environment(ChallengesVM(interactor: TestInteractor()))
            .environment(SocialVM(interactor: TestInteractor()))
            .preferredColorScheme(.dark)
    }
}

