import SwiftUI

struct RankingsView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LabeledHeader(title: "Rankings")
                
                LazyVStack(spacing: 20) {
                    ForEach(gamesVM.games) { game in
                        NavigationLink(value: game) {
                            HStack(spacing: 10) {
                                GameCover(game: game, width: 60, height: 60)
                                    .namespace(nil)
                                Text(game.name)
                                    .font(.customBody)
                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
    }
}

#Preview {
    RankingsView()
        .environment(GamesVM(interactor: TestInteractor()))
}
