import SwiftUI

struct GameRankingView: View {
    @State var rankingsVM: RankingsVM
    @State var animation: Bool = false
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        if let game = rankingsVM.selectedGame {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .firstTextBaseline, spacing: 20) {
                        BackButton {
                            withAnimation(.snappy) {
                                rankingsVM.selectedGame = nil
                            }
                        }
                        .opacity(animation ? 1.0 : 0.0)
                        
                        if let namespace {
                            Text(game.name)
                                .font(.customLargeTitle)
                                .matchedGeometryEffect(id: "\(game.id)_NAME", in: namespace, properties: .position)
                        }
                    }
                    
                    Group {
                        if rankingsVM.rankingScores.count > 0 {
                            LazyVStack {
                                ForEach(rankingsVM.ranking, id: \.element.id) { index, rankingScore in
                                    RankingScoreCell(index: index, rankingScore: rankingScore)
                                }
                            }
                        } else {
                            CustomUnavailableView(title: "No scores", image: "gamecontroller",
                                                  description: "There isn't any score for this game yet.")
                        }
                    }
                    .opacity(animation ? 1.0 : 0.0)
                }
            }
            .onAppear {
                rankingsVM.getGameRanking(id: game.id)
                withAnimation(.easeOut.delay(0.3)) {
                    animation = true
                }
            }
            .onDisappear {
                animation = false
            }
            .padding(.horizontal)
            .background(Color.background)
            .navigationBarBackButtonHidden()
            .scrollBounceBehavior(.basedOnSize)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    GameRankingView(rankingsVM: RankingsVM(interactor: TestInteractor(), selectedGame: .test))
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}

