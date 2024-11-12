import SwiftUI

fileprivate struct UserPopup: ViewModifier {
    @Environment(SocialVM.self) private var socialVM
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            if socialVM.selectedUser != nil {
                                withAnimation {
                                    socialVM.selectedUser = nil
                                }
                            }
                        }
                        .opacity(socialVM.selectedUser != nil ? 1.0 : 0.0)
                    
                    UserCard(user: socialVM.selectedUser)
                }
                
            }
            
    }
}

extension View {
    func userPopup() -> some View {
        modifier(UserPopup())
    }
    
}
