import SwiftUI

struct FollowsView: View {
    @Environment(SocialVM.self) private var socialVM
    @Environment(\.dismiss) private var dismiss
    @State var selectedPage: ProfilePage
    
    @Namespace private var namespace
    
    var body: some View {
        VStack {
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
        .background(Color.background)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    FollowsView(selectedPage: .followers)
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}

