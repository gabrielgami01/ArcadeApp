import SwiftUI

struct ConnectionsCell: View {
    @Environment(SocialVM.self) private var socialVM
    
    let user: User
    
    var body: some View {
        HStack {
            UserAvatarImage(imageData: user.avatarImage, size: 60)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.customTitle3)
                Text(user.fullName)
                    .font(.customFootnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            ConnectionsButton(user: user)
            
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    ConnectionsCell(user: .test)
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
        .padding()
}
