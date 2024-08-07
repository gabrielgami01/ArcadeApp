import SwiftUI

struct GameInfoCard: View {
    let game: Game
    let width: CGFloat
    let height: CGFloat
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            if let namespace = namespace {
                Text(game.name)
                    .font(.customHeadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.accent)
                    .matchedGeometryEffect(id: "\(game.id)/NAME", in: namespace)
            }
            HStack(spacing: 10) {
                Text(game.console.rawValue)
                    .enumTag()
                Text(game.genre.rawValue)
                    .enumTag()
            }
            Text(game.description)
                .font(.customCaption)
                .padding(.horizontal)
        }
        .padding(.vertical)
        .padding(.horizontal, 5)
        .frame(width: width, height: height, alignment: .top)
        .scrollBounceBehavior(.basedOnSize)
        .customCard(borderColor: .accent, cornerRadius: 10)
    }
}

#Preview {
    GameInfoCard(game: .test, width: UIDevice.width / 2, height: 220 * 0.8)
        .namespace(Namespace().wrappedValue)
}
