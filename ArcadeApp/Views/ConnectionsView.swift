import SwiftUI

struct ConnectionsView: View {
    @Environment(SocialVM.self) private var socialVM
    
    @State var selectedPage: ConnectionOptions
    
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 15) {
                BackButton()
                
                CustomPicker(selected: $selectedPage, displayKeyPath: \.rawValue)
                    .namespace(namespace)
            }
            .padding(.horizontal)
            
            ZStack {
                if selectedPage == .following {
                    ConnectionsListView(type: .following)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                }
                
                if selectedPage == .followers {
                    ConnectionsListView(type: .followers)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
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

        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
    }
}

#Preview {
    ConnectionsView(selectedPage: .followers)
        .environment(UserVM(repository: TestRepository()))
        .environment(ChallengesVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}

