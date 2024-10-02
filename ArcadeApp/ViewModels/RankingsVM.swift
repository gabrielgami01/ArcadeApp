import SwiftUI

@Observable
final class RankingsVM {
    let interactor: DataInteractor
    
    var rankingScores: [RankingScore] = []
    @ObservationIgnored var ranking: [(offset: Int, element: RankingScore)] {
        rankingScores.enumerated().map { $0 }
    }
    
    var rankingsPage = 1
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    func getGameRanking(id: UUID) async {
        do {
            let rankingScores = try await interactor.getGameRanking(id: id, page: rankingsPage)
            await MainActor.run {
                self.rankingScores = rankingScores
            }
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func isLastScore(_ score: RankingScore, gameID: UUID) {
        if rankingScores.last?.id == score.id {
            rankingsPage += 1
            Task {
               await getGameRanking(id: gameID)
            }
        }
    }
}
