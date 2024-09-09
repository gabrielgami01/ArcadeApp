import SwiftUI

struct GameRankingCell: View {
    let game: Game
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        HStack(spacing: 15) {
            GameCover(game: game, width: 65, height: 65)
                
            if let namespace {
                Text(game.name)
                    .font(.customHeadline)
                    .matchedGeometryEffect(id: "\(game.id)_NAME", in: namespace, properties: .position)
            }
            
            Spacer()
            
            Text(">")
                .font(.customTitle2)
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 10))  
    }
    
}

#Preview {
    GameRankingCell(game: .test)
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}
