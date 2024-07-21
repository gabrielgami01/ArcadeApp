import SwiftUI

struct GameCover: View {
    let game: Game
    let width: CGFloat
    let height: CGFloat
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        if let namespace {
            if let image = game.imageURL {
                Image(game.name)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: width, height: height)
                    .matchedGeometryEffect(id: "\(game.id)-cover", in: namespace)
            } else {
                RoundedRectangle(cornerRadius: 20)
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
        } else {
            if let image = game.imageURL {
                Image(game.name)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: width, height: height)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(white: 0.6))
                    .overlay {
                        Image(systemName: "gamecontroller")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.primary)
                            .padding()
                    }
                    .frame(width: width, height: height)
            }
        }
    }
}

#Preview {
    GameCover(game: .test, width: 160, height: 220)
}
