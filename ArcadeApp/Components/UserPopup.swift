import SwiftUI

fileprivate struct UserPopup: ViewModifier {
    @Binding var selectedUser: User?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            if selectedUser != nil {
                                withAnimation {
                                    selectedUser = nil
                                }
                            }
                        }
                        .opacity(selectedUser != nil ? 1.0 : 0.0)
                    
                    if let selectedUser {
                        UserCard(user: selectedUser)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                
            }
            
    }
}

extension View {
    func userPopup(selectedUser: Binding<User?>) -> some View {
        modifier(UserPopup(selectedUser: selectedUser))
    }
    
}
