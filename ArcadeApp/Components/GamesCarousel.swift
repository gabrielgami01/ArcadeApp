import SwiftUI

struct GamesCarousel: View {
    @Environment(GamesVM.self) private var gamesVM
    
    @Binding var selectedType: HomeScrollType
    @Binding var activeNamespace: Namespace.ID?
    let type: HomeScrollType
    
    private var games: [Game] {
        switch type {
            case .featured: gamesVM.featured
            case .favorites: gamesVM.favorites
        }
    }
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(LocalizedStringKey(type.rawValue.uppercased()))
                .font(.customTitle3)
                .padding(.horizontal)
            
            if !games.isEmpty{
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(games) { game in
                            if game.id != gamesVM.selectedGame?.id || selectedType.id != type.id {
                                Button {
                                    selectedType = type
                                    activeNamespace = namespace
                                    withAnimation {
                                        gamesVM.selectedGame = game
                                    }
                                } label: {
                                    CarouselCell(game: game)
                                }
                                .buttonStyle(.plain)
                            } else {
                                Color.clear
                                    .frame(width: 140, height: 220)
                            }
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
    GamesCarousel(selectedType: .constant(.favorites), activeNamespace: .constant(nil), type: .favorites)
        .environment(GamesVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}
