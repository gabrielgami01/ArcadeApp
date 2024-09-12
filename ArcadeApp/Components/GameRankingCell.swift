import SwiftUI

struct GameRankingCell: View {
    let game: Game
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 15) {
                GameCover(game: game, width: 60, height: 60)
                                        
                if let namespace {
                    Text(game.name)
                        .font(.customHeadline)
                        .matchedGeometryEffect(id: "\(game.id)_NAME", in: namespace, properties: .position)
                }
                
                Spacer()
                
                Text(">")
                    .font(.customTitle2)
            }
            
            Divider()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.background)
    }
    
}

#Preview {
    GameRankingCell(game: .test)
        .padding()
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}



