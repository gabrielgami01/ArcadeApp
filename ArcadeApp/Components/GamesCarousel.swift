import SwiftUI

struct GamesCarousel: View {
    @Environment(GamesVM.self) private var gamesVM
    let type: HomeScrollType
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        let games = type == .favorites ? gamesVM.favorites : gamesVM.featured
        
        VStack(alignment: .leading, spacing: 5) {
            Text(type.rawValue.uppercased())
                .font(.customTitle3)
                .padding(.horizontal)
            
            if !games.isEmpty {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        if let namespace {
                            ForEach(games) { game in
                                VStack {
                                    Button {
                                        gamesVM.selectedGame = game
                                        gamesVM.selectedType = type
                                    } label: {
                                        GameCover(game: game, width: 140, height: 220)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Text(game.name)
                                        .font(.customSubheadline)
                                        .frame(width: 140)
                                        .lineLimit(2, reservesSpace: true)
                                        .multilineTextAlignment(.center)
                                        .matchedGeometryEffect(id: "\(game.id)/NAME", in: namespace)
                                }
                                .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.4)
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                                    //      .opacity(phase.value < 0 ? 0.4 : 1)
                                    //      .scaleEffect(phase.value < 0 ? 0.8 : 1)
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
                if type == .favorites {
                    CustomUnavailableView(title: "No favorite games", image: "gamecontroller",
                                          description: "You haven't any favorite game yet.")
                } else {
                    CustomUnavailableView(title: "No featured games", image: "gamecontroller", 
                                          description: "There isn't any featured game by the moment.")
                }
            }
        }
    }
}

#Preview {
    GamesCarousel(type: .favorites)
        .environment(GamesVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
}
