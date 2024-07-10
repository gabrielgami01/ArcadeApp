import SwiftUI

struct GameCoverFull: View {
    let game: Game
    
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
        .frame(width: .infinity, height: 350)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .primary.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    GameCoverFull(game: .test)
}
