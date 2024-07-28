import SwiftUI

struct GameDetailsCard: View {
    @State var detailsVM: GameDetailsVM
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                if let namespace = namespace {
                    Text(detailsVM.game.name)
                        .font(.customTitle2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.cyan)
                        .matchedGeometryEffect(id: "\(detailsVM.game.id)-name", in: namespace)
                } else {
                    Text(detailsVM.game.name)
                        .font(.customTitle2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.cyan)
                }
            }
            HStack(spacing: 10) {
                Text(detailsVM.game.console.rawValue)
                    .enumTag()
                Text(detailsVM.game.genre.rawValue)
                    .enumTag()
            }
            Text("Release date: \(detailsVM.game.releaseDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.customCaption)
                .foregroundColor(.white)

            HStack(alignment: .lastTextBaseline, spacing: 5) {
                RatingComponent(rating: .constant(Int(detailsVM.globalRating)), mode: .display)
                Text("(\(detailsVM.globalRating.formatted(.number.precision(.fractionLength(1)))))")
                    .font(.customCaption)
                    .foregroundColor(.yellow)
            }
            HStack {
                Button {
                    detailsVM.useFavorite()
                } label: {
                    Image(systemName: "heart")
                        .font(.title2)
                        .symbolVariant(detailsVM.favorite ? .fill : .none)
                        .tint(detailsVM.favorite ? .red : .cyan)
                }
                Text("Like")
                    .font(.customCaption)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .customCard()
    }
}

#Preview {
    GameDetailsCard(detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test))
}
