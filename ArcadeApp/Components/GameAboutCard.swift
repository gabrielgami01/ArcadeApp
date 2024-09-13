import SwiftUI

struct GameAboutCard: View {
    @Environment(GamesVM.self) private var gamesVM
    @State var detailsVM: GameDetailsVM
    
    let game: Game
    let animation: Bool
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
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
            }
            
            Group {
                HStack(spacing: 10) {
                    Text(game.console.rawValue)
                        .enumTag()
                    Text(game.genre.rawValue)
                        .enumTag()
                }
                
                Text("Release date: \(game.releaseDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.customCaption)
                
                HStack(alignment: .lastTextBaseline, spacing: 5) {
                    RatingComponent(rating: .constant(Int(detailsVM.globalRating)), mode: .display)
                    Text("(\(detailsVM.globalRating.formatted(.number.precision(.fractionLength(1)))))")
                        .font(.customCaption)
                        .foregroundColor(.yellow)
                }
                HStack {
                    Button {
                        Task {
                            if await detailsVM.useFavorite(gameID: game.id) {
                                detailsVM.isFavorite.toggle()
                                gamesVM.toggleFavoriteGame(game: game, favorite: detailsVM.isFavorite)
                            }
                        }
                    } label: {
                        Image(systemName: "heart")
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

#Preview {
    GameAboutCard(detailsVM: GameDetailsVM(interactor: TestInteractor()), game: .test, animation: true)
        .environment(GamesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
