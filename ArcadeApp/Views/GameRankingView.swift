import SwiftUI

struct GameRankingView: View {
    @State var rankingVM: RankingsVM
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LabeledHeader(title: rankingVM.game.name)
                
                if rankingVM.rankingScores.count > 0 {
                    LazyVStack {
                        ForEach(rankingVM.ranking, id: \.element.id) { index, rankingScore in
                            RankingScoreCell(index: index, rankingScore: rankingScore)
                        }
                    }
                } else {
                    CustomUnavailableView(title: "No scores", image: "gamecontroller",
                                          description: "There isn't any score for this game yet.")
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
    GameRankingView(rankingVM: RankingsVM(interactor: TestInteractor(), game: .test))
}

