import SwiftUI

struct GameCell: View {
    let game: Game
    let animation: Game?
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        HStack(spacing: -25) {
            VStack(alignment: .center, spacing: 10) {
                if let namespace{
                    Text(game.name)
                        .font(.customHeadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.accent)
                        .matchedGeometryEffect(id: "\(game.id)_NAME", in: namespace, properties: .position)
                }
                
                HStack(spacing: 10) {
                    Text(game.console.rawValue)
                        .enumTag()
                    Text(LocalizedStringKey(game.genre.rawValue))
                        .enumTag()
                }
                
                Text(game.description)
                    .font(.customCaption)
                    .padding(.horizontal)
            }
            .padding(.vertical)
            .padding(.horizontal, 5)
            .frame(width: 200, height: 175, alignment: .top)
            .customCard(borderColor: .accent, cornerRadius: 10)
            .zIndex(1)
            .offset(x: animation?.id == game.id ? -25 : 0 )
            
            GameCover(game: game, width: 170, height: 210)
                .shadow(color: .accent, radius: 8)
        }
    }
}

#Preview {
    GameCell(game: .test, animation: .test)
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}



