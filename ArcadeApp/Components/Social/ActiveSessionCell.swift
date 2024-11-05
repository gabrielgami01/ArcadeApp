import SwiftUI

struct ActiveSessionCell: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SessionVM.self) private var sessionVM
    
    
    var body: some View {
        if let activeUser = userVM.activeUser {
            VStack {
                UserAvatarImage(imageData: activeUser.avatarImage, size: 80)
                    .overlay {
                        Group {
                            if let activeSession = sessionVM.activeSession {
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
}

#Preview {
    ActiveSessionCell()
        .environment(UserVM(repository: TestRepository()))
        .environment(SessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
