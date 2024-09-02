import SwiftUI

@Observable
final class RankingsVM {
    let interactor: DataInteractor
    
    var games: [Game] = []
    
    var selectedGame: Game?
    
    var rankingScores: [RankingScore] = []
    var ranking: [(offset: Int, element: RankingScore)] {
        rankingScores.enumerated().map { $0 }
    }
    
    var gamesPage = 1
    var rankingsPage = 1
    
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared, selectedGame: Game? = nil) {
        self.interactor = interactor
        self.selectedGame = selectedGame
        getGames()
    }
    
    func getGames() {
        Task {
            do {
                games += try await interactor.getAllGames(page: gamesPage)
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func getGameRanking(id: UUID) {
        Task {
            do {
                rankingScores = try await interactor.getGameRanking(id: id, page: rankingsPage)
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func isLastScore(_ score: RankingScore, gameID: UUID) {
        if rankingScores.last?.id == score.id {
            rankingsPage += 1
            getGameRanking(id: gameID)
        }
    }
    
    func isLastGame(_ game: Game) {
        if games.last?.id == game.id {
            gamesPage += 1
            getGames()
        }
    }
    
}
