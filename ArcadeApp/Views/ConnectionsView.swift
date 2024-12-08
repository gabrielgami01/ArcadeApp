import SwiftUI

struct ConnectionsView: View {
    @Environment(SocialVM.self) private var socialVM
    
    @State var selectedPage: ConnectionOptions
    
    var body: some View {
        @Bindable var socialBVM = socialVM
        
        ScrollView {
            ZStack {
                if selectedPage == .following {
                    ConnectionsList(connections: socialVM.following, type: .following) { user in
                        withAnimation {
                            socialVM.selectedUser = user
                        }
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
                
                if selectedPage == .followers {
                    ConnectionsList(connections: socialVM.followers, type: .followers) { user in
                        withAnimation {
                            socialVM.selectedUser = user
                        }
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    withAnimation(.bouncy){
                        if value.startLocation.x > value.location.x {
                            selectedPage = .followers
                        } else if value.startLocation.x < value.location.x {
                            selectedPage = .following
                        }
                    }
                }
        )
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .principal) {
                CustomPicker(selected: $selectedPage)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
        .errorAlert(show: $socialBVM.showError)
    }
}

#Preview {
    NavigationStack {
        ConnectionsView(selectedPage: .followers)
            .environment(SocialVM(repository: TestRepository()))
            .preferredColorScheme(.dark)
    }
}

