import SwiftUI

struct GameAboutCard: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(GameDetailsVM.self) private var detailsVM
    
    let game: Game
    let animation: Bool
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        HStack(spacing: 10) {
            GameCover(game: game, width: 150, height: 220)
            
            VStack(alignment: .leading, spacing: 10) {
                if let namespace = namespace {
                    Text(game.name)
                        .font(.customHeadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accent)
                        .matchedGeometryEffect(id: "\(game.id)_NAME", in: namespace, properties: .position)
                } else {
                    Text(game.name)
                        .font(.customHeadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accent)
                }
                
                Group {
                    HStack(spacing: 5) {
                        Text(game.console.rawValue)
                            .enumTag()
                        Text(LocalizedStringKey(game.genre.rawValue))
                            .enumTag()
                    }
                    
                    Text("Release date: \(game.releaseDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.customCaption)
                    
                    RatingComponent(rating: .constant(Int(detailsVM.globalRating)), mode: .display)
                    
                    HStack {
                        Button {
                            Task {
                                if await detailsVM.toggleFavorite(gameID: game.id) {
                                    detailsVM.isFavorite.toggle()
                                    gamesVM.toggleFavoriteGame(game: game, favorite: detailsVM.isFavorite)
                                }
                            }
                        } label: {
                            Image(systemName: "heart")
                                .symbolEffect(.bounce, value: detailsVM.isFavorite)
                                .font(.title2)
                                .symbolVariant(detailsVM.isFavorite ? .fill : .none)
                                .tint(detailsVM.isFavorite ? .red : .accent)
                        }
                        Text("Like")
                            .font(.customCaption)
                    }
                }
                .offset(x: animation ? 0 : UIDevice.width)
                .animation(.easeOut.delay(0.4), value: animation)
            }
            .padding()
            .customCard(borderColor: .accent, cornerRadius: 10)
            .frame(height: 220)
        }
    }
}

#Preview {
    GameAboutCard(game: .test, animation: true)
        .environment(GamesVM(repository: TestRepository()))
        .environment(GameDetailsVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
