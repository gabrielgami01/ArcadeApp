import SwiftUI

struct GameCover: View {
    let game: Game
    
    var body: some View {
        Group {
            if let image = game.imageURL {
                
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(white: 0.9))
                    .overlay {
                        Image(systemName: "gamecontroller")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.secondary)
                            .padding()
                    }
            }
        }
        .frame(width: 160, height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .primary.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    GameCover(game: .test)
}
