import SwiftUI

@Observable
final class RankingsVM {
    let interactor: DataInteractor
    let game: Game
    
    var rankingScores: [RankingScore] = []
    var ranking: [(offset: Int, element: RankingScore)] {
        rankingScores.enumerated().map { $0 }
    }
    
    var page = 1
    
    var errorMsg = ""
    var showAlert = false
    
    
    init(interactor: DataInteractor = Network.shared, game: Game) {
        self.interactor = interactor
        self.game = game
        getRanking()
    }
    
    func getRanking() {
        Task {
            do {
                self.rankingScores = try await interactor.getGameRanking(id: game.id, page: page)
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func isLastItem(_ score: RankingScore) {
        if rankingScores.last?.id == score.id {
            page += 1
            getRanking()
        }
    }
    
}
