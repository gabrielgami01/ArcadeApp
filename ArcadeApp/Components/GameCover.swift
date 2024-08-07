import SwiftUI
import ACNetwork

struct GameCover: View {
    let game: Game
    let width: CGFloat
    let height: CGFloat
    var shimmer: Bool = false
    
    @Environment(\.namespace) private var namespace
    @State private var imageVM = ImageNetworkVM()
    
    var body: some View {
        Group {
            if let namespace {
                if let image = imageVM.image {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: width, height: height)
                        .matchedGeometryEffect(id: "\(game.id)/COVER", in: namespace)
                        .shimmerEffect(active: shimmer)
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
                        .matchedGeometryEffect(id: "\(game.id)/COVER", in: namespace)
                        .frame(width: width, height: height)
                        .shimmerEffect(active: shimmer)
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
                }
            }
        }
        .task {
           await imageVM.getImage(url: game.imageURL, size: 300)
        }
    }
}

#Preview {
    GameCover(game: .test2, width: 160, height: 220, shimmer: true)
        .namespace(Namespace().wrappedValue)
}
