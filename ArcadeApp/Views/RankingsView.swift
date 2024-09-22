import SwiftUI

struct RankingsView: View {
    @Environment(GamesVM.self) private var gamesVM
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(gamesVM.games) { game in
                    NavigationLink(value: game) {
                        GameRankingCell(game: game)
                            .onAppear {
                                gamesVM.isLastItem(game)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            if gamesVM.activeConsole != .all {
                gamesVM.activeConsole = .all
            }
        }
        .headerToolbar(title: "Rankings")
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        RankingsView()
            .environment(GamesVM(interactor: TestInteractor()))
            .preferredColorScheme(.dark)
            .namespace(Namespace().wrappedValue)
    }
}
