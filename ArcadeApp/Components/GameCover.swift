import SwiftUI

struct GameCover: View {
    let game: Game
    var width: CGFloat = 160
    var height: CGFloat = 260
    
    var body: some View {
        Group {
            if let image = game.imageURL {
                
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(white: 0.6))
                    .overlay {
                        Image(systemName: "gamecontroller")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.primary)
                            .padding()
                    }
            }
        }        
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .primary.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    GameCover(game: .test, width: 160, height: 260)
}
