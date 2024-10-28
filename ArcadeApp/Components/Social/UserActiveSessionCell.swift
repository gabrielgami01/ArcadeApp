import SwiftUI

struct UserActiveSessionCell: View {
    let user: User
    let game: String
    
    var body: some View {
        VStack {
            UserAvatarImage(imageData: user.avatarImage, size: 80)
                .overlay {
                    Text(game)
                        .font(.customFootnote)
                        .multilineTextAlignment(.center)
                        .frame(width: 70)
                        .padding(5)
                        .background(Color.card, in: RoundedRectangle(cornerRadius: 20))
                        .offset(y: -20)
                    
                }
            
            Text(user.username)
                .font(.customCallout)
        }
    }
}

#Preview {
    UserActiveSessionCell(user: .test2, game: Game.test.name)
}
