import SwiftUI

struct GamesCarousel: View {
    @Environment(GamesVM.self) private var gamesVM
    let type: HomeScrollType
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        let games = type == .favorites ? gamesVM.favorites : gamesVM.featured
        
        VStack(alignment: .leading, spacing: 5) {
            Text(type.rawValue.uppercased())
                .font(.customHeadline)
                .padding(.horizontal)
            
            if !games.isEmpty {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        if let namespace {
                            ForEach(games) { game in
                                VStack {
                                    Button {
                                        gamesVM.homeType = type
                                        gamesVM.selectedGame = game
                                    } label: {
                                        GameCover(game: game, width: 140, height: 220)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Text(game.name)
                                        .font(.customFootnote)
                                        .frame(width: 140)
                                        .lineLimit(2, reservesSpace: true)
                                        .multilineTextAlignment(.center)
                                        .matchedGeometryEffect(id: "\(game.id)-name", in: namespace)
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
                    ContentUnavailableView("No favorite games", systemImage: "gamecontroller",
                                           description: Text("You haven't any favorite game yet."))
                } else {
                    ContentUnavailableView("No featured games", systemImage: "gamecontroller",
                                           description: Text("There isn't any featured game by the moment."))
                }
            }
        }
    }
}

struct GamesCarouselPro: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(\.namespace) private var namespace
    @Binding var selectedGame: UUID?
    let type: HomeScrollType
    
    let opacityValue: CGFloat = 0.5
    let scaleValue: CGFloat = 0.2
    
    let cardWidth: CGFloat = 120
    let cardHeight: CGFloat = 220
    let spacing: CGFloat = 10
    let cornerRadius: CGFloat = 15
    let minimumCardWidth: CGFloat = 40
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    ForEach(type == .favorites ? gamesVM.favorites : gamesVM.featured) { game in
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
                            let progress = minX / (cardWidth + spacing)
                            let minimumCardWidth = minimumCardWidth
                            
                            let diffWidth = cardWidth - minimumCardWidth
                            let reducingWidth = progress * diffWidth
                            let cappedWidth = min(reducingWidth, diffWidth)
                            
                            let resizedFrameWidth = size.width - (minX > 0 ? cappedWidth : min(-cappedWidth, diffWidth))
                            let negativeProgress = max(-progress, 0)
                            
                            let scaleValue = scaleValue * abs(progress)
                            let opacityValue = opacityValue * abs(progress)
                            
                            GameCover(game: game, width: cardWidth, height: cardHeight)
                                //.frame(width: size.width, height: size.height)
                                .frame(width: resizedFrameWidth)
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                                .opacity(1 - opacityValue)
                                //.scaleEffect(1 - scaleValue)
                                .offset(x: -reducingWidth)
                                .offset(x: min(progress,1) * diffWidth)
                                .offset(x: negativeProgress * diffWidth)
                        }
                        .frame(width: cardWidth)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, (size.width - cardWidth) / 2)
            .scrollPosition(id: $selectedGame)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.hidden)
        }
    }
}



#Preview {
    GamesCarousel(type: .favorites)
        .environment(GamesVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
}
