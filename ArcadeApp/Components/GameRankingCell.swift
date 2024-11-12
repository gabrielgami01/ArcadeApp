import SwiftUI

struct GameRankingCell: View {
    let game: Game
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 15) {
                GameCover(game: game, width: 60, height: 60)
                                        
                Text(game.name)
                    .font(.customHeadline)
                
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
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}



