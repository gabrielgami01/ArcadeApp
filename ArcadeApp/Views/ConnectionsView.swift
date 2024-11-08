import SwiftUI

struct ConnectionsView: View {
    @Environment(SocialVM.self) private var socialVM
    
    @State var selectedPage: ConnectionOptions
    
    @Namespace private var namespace
    
    var body: some View {
        ScrollView {
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .principal) {
                CustomPicker(selected: $selectedPage)
                    .namespace(namespace)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        ConnectionsView(selectedPage: .followers)
            .environment(SocialVM(repository: TestRepository()))
            .preferredColorScheme(.dark)
    }
}

