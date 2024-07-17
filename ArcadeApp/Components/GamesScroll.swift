import SwiftUI

struct GamesScroll: View {
    let type: HomeScrollType
    let namespace: Namespace.ID
    
    @Environment(GamesVM.self) private var gamesVM
    
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
                            VStack {
                                GameCover(game: game, width: 140, height: 220, namespace: namespace)
                                Text(game.name)
                                    .font(.footnote)
                                    .frame(width: 140)
                                    .lineLimit(2, reservesSpace: true)
                                    .multilineTextAlignment(.center)
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
    GamesScroll(type: .favorites, namespace: Namespace().wrappedValue)
        .environment(GamesVM(interactor: TestInteractor()))
}
