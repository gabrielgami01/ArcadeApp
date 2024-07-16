import SwiftUI

struct GameDetailsCard: View {
    @State var detailsVM: GameDetailsVM
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(detailsVM.game.name)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .matchedGeometryEffect(id: "\(detailsVM.game.id)-name", in: namespace)
            Text("Release date: \(detailsVM.game.releaseDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(alignment: .lastTextBaseline, spacing: 5) {
                RatingComponent(rating: .constant(Int(detailsVM.globalRating)), mode: .display)
                Text("(\(detailsVM.globalRating.formatted(.number.precision(.fractionLength(1)))))")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
            HStack {
                Button {
                    detailsVM.useFavorite()
                } label: {
                    Image(systemName: "heart")
                        .font(.title2)
                        .symbolVariant(detailsVM.favorite ? .fill : .none)
                        .tint(detailsVM.favorite ? .red : .blue)
                }
                Text("Like")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        
    }
}

#Preview {
    GameDetailsCard(detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test), namespace: Namespace().wrappedValue)
}
