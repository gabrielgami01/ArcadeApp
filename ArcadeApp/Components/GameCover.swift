import SwiftUI

struct GameCover: View {
    @State private var imageVM = ImageVM()
    
    let game: Game
    let width: CGFloat
    let height: CGFloat
     
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
        .onAppear {
            imageVM.getImage(url: game.imageURL)
        }
    }
}

#Preview {
    GameCover(game: .test, width: 140, height: 220)
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}
