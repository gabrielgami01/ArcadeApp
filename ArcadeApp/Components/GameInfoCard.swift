import SwiftUI

struct GameInfoCard: View {
    let game: Game
    let width: CGFloat
    let height: CGFloat
    
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
        .frame(width: width, height: height)
        .scrollBounceBehavior(.basedOnSize)
        .customCard()
    }
}

#Preview {
    GameInfoCard(game: .test, width: UIDevice.width / 2, height: 220 * 0.8)
        .namespace(Namespace().wrappedValue)
}
