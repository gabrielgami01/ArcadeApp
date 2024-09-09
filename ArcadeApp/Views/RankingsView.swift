import SwiftUI

struct RankingsView: View {
    @State var rankingsVM = RankingsVM()
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                CustomHeader(title: "Rankings")
                
                LazyVStack(spacing: 20) {
                    ForEach(rankingsVM.games) { game in
                        Button {
                            withAnimation(.snappy) {
                                rankingsVM.selectedGame = game
                            }
                        } label: {
                            GameRankingCell(game: game)
                            .onAppear {
                                rankingsVM.isLastGame(game)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.horizontal)
        .overlay {
            GameRankingView(rankingsVM: rankingsVM)
        }
        .background(Color.background)
        .navigationBarBackButtonHidden()
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    NavigationStack {
        RankingsView(rankingsVM: RankingsVM(interactor: TestInteractor()))
            .environment(UserVM(interactor: TestInteractor()))
            .preferredColorScheme(.dark)
            .namespace(Namespace().wrappedValue)
    }
}
