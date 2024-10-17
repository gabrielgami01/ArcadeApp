import SwiftUI

@Observable
final class RankingsVM {
    let repository: RepositoryProtocol
    
    var rankingScores: [RankingScore] = []
    @ObservationIgnored var ranking: [(offset: Int, element: RankingScore)] {
        rankingScores.enumerated().map { $0 }
    }
    
    var rankingsPage = 1
    
    var errorMsg = ""
    var showError = false
    
    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
    }
    
    func getGameRanking(id: UUID) async {
        do {
            let rankingScores = try await repository.getGameRanking(id: id, page: rankingsPage)
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
