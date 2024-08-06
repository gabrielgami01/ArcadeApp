import SwiftUI

struct GameCoverCard: View {
    let game: Game
    let width: CGFloat
    let height: CGFloat
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            GameCover(game: game, width: width / 2.5, height: height, shimmer: true)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 0 : 1)
            GameCoverBack(game: game)
                .frame(width: width / 2.5, height: height)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 1 : 0)
            
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                isFlipped.toggle()
            }
         }
    }
}

#Preview {
    GameCoverCard(game: .test, width: 300, height: 220)
}
