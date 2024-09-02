import SwiftUI
import ACNetwork

struct GameCover: View {
    let game: Game
    let width: CGFloat
    let height: CGFloat
    @State private var imageVM = ImageNetworkVM()    
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        Group {
            if let namespace {
                if let image = imageVM.image {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .matchedGeometryEffect(id: "\(game.id)_COVER", in: namespace)
                        .frame(width: width, height: height)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(white: 0.6))
                        .overlay {
                            Image(systemName: "gamecontroller")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.primary)
                                .padding()
                        }
                        .matchedGeometryEffect(id: "\(game.id)_COVER", in: namespace)
                        .frame(width: width, height: height)
                        .shimmerEffect()
                }
            } else {
                if let image = imageVM.image {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: width, height: height)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(white: 0.6))
                        .overlay {
                            Image(systemName: "gamecontroller")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.primary)
                                .padding()
                        }
                        .frame(width: width, height: height)
                        .shimmerEffect()
                }
            }
        }
        .task {
            await imageVM.getImage(url: game.imageURL, size: 300)
        }
    }
}

#Preview {
    GameCover(game: .test, width: 140, height: 220)
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}
