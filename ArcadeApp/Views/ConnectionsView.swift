import SwiftUI

struct ConnectionsView: View {
    @Environment(SocialVM.self) private var socialVM
    
    @State var selectedPage: ConnectionOptions
    
    @Environment(\.dismiss) private var dismiss
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                BackButton {
                    dismiss()
                }
                
                CustomPicker(selected: $selectedPage, displayKeyPath: \.rawValue)
                    .namespace(namespace)
            }
            
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
        .padding(.horizontal)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
    }
}

#Preview {
    ConnectionsView(selectedPage: .followers)
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}

