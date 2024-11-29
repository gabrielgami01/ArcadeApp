import SwiftUI

struct GamesCarousel: View {
    let games: [Game]
    let type: HomeScrollType
    let onGameSelect: (Game) -> Void
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(LocalizedStringKey(type.rawValue.uppercased()))
                .font(.customTitle3)
                .padding(.horizontal)
            
            if !games.isEmpty {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(games) { game in
                            Button {
                                onGameSelect(game)
                            } label: {
                                CarouselCell(game: game)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .safeAreaPadding(.horizontal)
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
            } else {
                switch type {
                    case .featured:
                        CustomUnavailableView(title: "No featured games", image: "gamecontroller",
                                              description: "There isn't any featured game by the moment.")
                    case .favorites:
                        CustomUnavailableView(title: "No favorite games", image: "gamecontroller",
                                              description: "You haven't any favorite game yet.")
                }
            }
        }
    }
}

#Preview {
    GamesCarousel(games: [.test, .test2], type: .featured) { _ in }
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}
