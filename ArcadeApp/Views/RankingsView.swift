import SwiftUI

struct RankingsView: View {
    @Environment(GamesVM.self) private var gamesVM
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        @Bindable var gamesBVM = gamesVM
        
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
        .refreshable {
            Task {
                await gamesVM.getGames()
            }
        }
        .tabBarInset()
        .headerToolbar(title: "Rankings")
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
        .errorAlert(show: $gamesBVM.showError)
    }
}

#Preview {
    NavigationStack {
        RankingsView()
            .environment(GamesVM(repository: TestRepository()))
            .preferredColorScheme(.dark)
            .namespace(Namespace().wrappedValue)
    }
}
