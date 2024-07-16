import SwiftUI

struct GameCover: View {
    let game: Game
    let width: CGFloat
    let height: CGFloat
    let namespace: Namespace.ID
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(white: 0.6))
            .overlay {
                Image(systemName: "gamecontroller")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.primary)
                    .padding()
            }
            .matchedGeometryEffect(id: "\(game.id)-cover", in: namespace)
            .frame(width: width, height: height)
    }
}

#Preview {
    GameCover(game: .test, width: 160, height: 220, namespace: Namespace().wrappedValue)
}
