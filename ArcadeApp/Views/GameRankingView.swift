import SwiftUI

struct GameRankingView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SocialVM.self) private var socialVM
    @State var rankingsVM = RankingsVM()
    
    let game: Game
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                if !rankingsVM.rankingScores.isEmpty {
                    ForEach(rankingsVM.ranking, id: \.element.id) { index, rankingScore in
                        Button {
                            if rankingScore.user.id != userVM.activeUser?.id {
                                withAnimation {
                                    socialVM.selectedUser = rankingScore.user
                                }
                            }  
                        } label: {
                            RankingScoreCell(rankingScore: rankingScore, index: index)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    CustomUnavailableView(title: "No scores", image: "gamecontroller",
                                          description: "There isn't any score for this game yet.")
                }
            }
            .padding(.horizontal)
        }
        .task {
            await rankingsVM.getGameRanking(id: game.id)
        }
        .refreshable {
            Task {
                await rankingsVM.getGameRanking(id: game.id)
            }
        }
        .tabBarInset()
        .headerToolbar(title: LocalizedStringKey(game.name))
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
        .errorAlert(show: $rankingsVM.showError)
    }
}

#Preview {
    NavigationStack {
        GameRankingView(rankingsVM: RankingsVM(repository: TestRepository()), game: .test)
            .environment(UserVM(repository: TestRepository()))
            .environment(SocialVM(repository: TestRepository()))
            .preferredColorScheme(.dark)
    }
}

