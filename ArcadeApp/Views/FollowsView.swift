import SwiftUI

struct FollowsView: View {
    @Environment(SocialVM.self) private var socialVM
    
    @State var selectedPage: ProfilePage
    
    @Environment(\.dismiss) private var dismiss
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                BackButton {
                    dismiss()
                }
                CustomPicker(activeSelection: $selectedPage) { $0.rawValue.capitalized }
                    .namespace(namespace)
            }
            
            ZStack {
                if selectedPage == .following {
                    FollowsListView(type: .following)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                }
                
                if selectedPage == .followers {
                    FollowsListView(type: .followers)
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
        .padding(.horizontal)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
    }
}

#Preview {
    FollowsView(selectedPage: .followers)
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}

