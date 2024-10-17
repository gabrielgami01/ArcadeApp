import SwiftUI

struct GamesCarousel: View {
    @Environment(GamesVM.self) private var gamesVM
    @Binding var selectedType: HomeScrollType
    let type: HomeScrollType
    let games: [Game]
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(LocalizedStringKey(type.rawValue.uppercased()))
                .font(.customTitle3)
                .padding(.horizontal)
            
            if !games.isEmpty{
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        if let namespace {
                            ForEach(games) { game in
                                if game.id != gamesVM.selectedGame?.id || selectedType.id != type.id {
                                    VStack {
                                        Button {
                                            selectedType = type
                                            withAnimation {
                                                gamesVM.selectedGame = game
                                            }
                                        } label: {
                                            GameCover(game: game, width: 140, height: 220)
                                        }
                                        .buttonStyle(.plain)
                                        
                                        Text(game.name)
                                            .font(.customSubheadline)
                                            .lineLimit(2, reservesSpace: true)
                                            .multilineTextAlignment(.center)
                                            .matchedGeometryEffect(id: "\(game.id)_NAME", in: namespace, properties: .position)
                                            .frame(width: 140)
                                    }
                                } else {
                                    Color.clear
                                        .frame(width: 140, height: 220)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
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
    GamesCarousel(selectedType: .constant(.favorites), type: .favorites, games: [.test,.test2])
        .environment(GamesVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}
