import SwiftUI

struct GameCard: View {
    let game: Game
    @Binding var selectedGame: Game?
    
    var body: some View {
        GeometryReader {
            let size = $0.size

            HStack(spacing: -25) {
                GameInfoCard(game: game)
                    .frame(width: size.width / 2, height: size.height * 0.8)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(white: 0.95))
                            .shadow(color: .primary.opacity(0.08), radius: 8, x: 5, y: 5)
                            .shadow(color: .primary.opacity(0.08), radius: 8, x: -5, y: -5)
                    }
                    .zIndex(1)
                    .offset(x: selectedGame == game ? -25 : 0)
                    .animation(.easeInOut.speed(0.8), value: selectedGame)

                ZStack {
                    GameCover(game: game, width: size.width / 2, height: size.height)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
        }
        .frame(width: UIDevice.width - 16, height: 220)
    }
}

#Preview {
    GameCard(game: .test, selectedGame: .constant(.test))
}

struct GameInfoCard: View {
    let game: Game
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                if let namespace{
                    Text(game.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .matchedGeometryEffect(id: "\(game.id)-name", in: namespace)
                }
                HStack (spacing: 10){
                    Text(game.console.rawValue)
                        .enumTag()
                    Text(game.genre.rawValue)
                        .enumTag()
                }
                Text(game.description)
                    .font(.caption2)
            }
            .padding(.vertical)
            .padding(.horizontal, 5)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

