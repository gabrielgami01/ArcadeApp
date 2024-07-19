import SwiftUI

struct GamesScroll: View {
    @Environment(GamesVM.self) private var gamesVM
    let type: HomeScrollType
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(type.rawValue.uppercased())
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(type == .favorites ? gamesVM.favorites : gamesVM.featured) { game in
                        //Text(gamesVM.games.count.formatted())
                        Button {
                            gamesVM.homeType = type
                            gamesVM.selectedGame = game
                        } label: {
                            if let namespace {
                                VStack {
                                    GameCover(game: game, width: 140, height: 220)
                                    Text(game.name)
                                        .font(.footnote)
                                        .frame(width: 140)
                                        .lineLimit(2, reservesSpace: true)
                                        .multilineTextAlignment(.center)
                                        .matchedGeometryEffect(id: "\(game.id)-name", in: namespace)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    GamesScroll(type: .favorites)
        .environment(GamesVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
}
