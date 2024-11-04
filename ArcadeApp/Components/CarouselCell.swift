import SwiftUI

struct CarouselCell: View {
    let game: Game
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        if let namespace {
            VStack {
                GameCover(game: game, width: 140, height: 220)
                
                Text(game.name)
                    .font(.customSubheadline)
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.center)
                    .matchedGeometryEffect(id: "\(game.id)_NAME", in: namespace, properties: .position)
            }
        }
    }
}

#Preview {
    CarouselCell(game: .test)
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}
