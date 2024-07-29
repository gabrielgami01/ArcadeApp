import SwiftUI

struct GameCard: View {
    let game: Game
    @Binding var selectedGame: Game?
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            HStack(spacing: -25) {
                GameInfoCard(game: game)
                    .frame(width: size.width / 2, height: size.height * 0.8)
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
    GameCard(game: .test, selectedGame: .constant(.test2))
        .namespace(Namespace().wrappedValue)
}

struct GameInfoCard: View {
    let game: Game
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                if let namespace = namespace {
                    Text(game.name)
                        .font(.customHeadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accent)
     
                        .matchedGeometryEffect(id: "\(game.id)-name", in: namespace)
                }
                HStack(spacing: 10) {
                    Text(game.console.rawValue)
                        .enumTag()
                    Text(game.genre.rawValue)
                        .enumTag()
                }
                Text(game.description)
                    .font(.customCaption)
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }
            .padding(.vertical)
            .padding(.horizontal, 5)
        }
        .scrollBounceBehavior(.basedOnSize)
        .customCard()
    }
}

