import SwiftUI

struct GameCardButton: View {
    let game: Game
    var size: CGSize? = nil
    let actions: () -> Void
    
    var body: some View {
        Button {
            actions()
        } label: {
            VStack {
                Group{
                    if let size {
                        GameCover(game: game, width: size.width, height: size.height)
                        Text(game.name)
                            .font(.footnote)
                            .frame(width: 120)
                    } else {
                        GameCover(game: game)
                        Text(game.name)
                            .font(.subheadline)
                            .frame(width: 160)
                    }
                }
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    GameCardButton(game: .test) {
        
    }
}
