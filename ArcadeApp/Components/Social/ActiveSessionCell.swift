import SwiftUI

struct SessionCell: View {
    let user: User
    let activeSession: Session?
    
    var body: some View {
        VStack {
            UserAvatarImage(imageData: user.avatarImage, size: 80)
                .overlay {
                    Group {
                        if let activeSession {
                            Text(activeSession.game.name)
                                .font(.customFootnote)
                                .multilineTextAlignment(.center)
                            
                        } else {
                            Text("Offline")
                                .font(.customFootnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: 70, height: 30)
                    .padding(5)
                    .background(Color.card, in: RoundedRectangle(cornerRadius: 20))
                    .offset(y: -20)
                }
            Text("Your session")
                .font(.customCallout)
        }
    }
}

#Preview {
    SessionCell(user: .test, activeSession: .test)
        .preferredColorScheme(.dark)
}
