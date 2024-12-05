import SwiftUI

@Observable
final class RankingsVM {
    let repository: RepositoryProtocol
    
    var rankingScores: [RankingScore] = []
    @ObservationIgnored var ranking: [(offset: Int, element: RankingScore)] {
        rankingScores.enumerated().map { $0 }
    }
    
    var showError = false
    
    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
    }
    
    func getGameRanking(id: UUID) async {
        do {
            let rankingScores = try await repository.getGameRanking(id: id)
            await MainActor.run {
                self.rankingScores = rankingScores
            }
        } catch {
            await MainActor.run {
                showError = true
            }
            print(error.localizedDescription)
        }
    }
}
