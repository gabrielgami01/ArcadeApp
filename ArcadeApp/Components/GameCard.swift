import SwiftUI

struct GameCard: View {
    let game: Game
    let namespace: Namespace.ID

    var body: some View {
        GeometryReader {
            let size = $0.size

            HStack(spacing: -25) {
                GameInfoCard(game: game, namespace: namespace)
                    .frame(width: size.width / 2, height: size.height * 0.8)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(white: 0.95))
                            .shadow(color: .primary.opacity(0.08), radius: 8, x: 5, y: 5)
                            .shadow(color: .primary.opacity(0.08), radius: 8, x: -5, y: -5)
                    }
                    .zIndex(1)

                ZStack {
                    GameCover(game: game, width: size.width / 2, height: size.height, namespace: namespace)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
        }
        .frame(width: UIDevice.width - 16, height: 220)
    }
}

#Preview {
    GameCard(game: .test, namespace: Namespace().wrappedValue)
}

struct GameInfoCard: View {
    let game: Game
    let namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                Text(game.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .matchedGeometryEffect(id: "\(game.id)-name", in: namespace)
                HStack (spacing: 10){
                    Text(game.console.rawValue)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .font(.caption)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.primary)
                        }
                    Text(game.genre.rawValue)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .font(.caption)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.primary)
                        }
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

