import Foundation

@Observable
final class GameDetailsVM {
    let interactor: DataInteractor
    let game: Game
    
    var favorite = false
    var reviews: [Review] = []
    var globalRating: Double {
        guard !reviews.isEmpty else { return 0.0 }
           
        let totalRating = reviews.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(reviews.count)
    }
    var scores: [Score] = []
    var verifiedScores: [Score] {
        scores.filter { $0.state == .verified }
    }
    
    
    var showAddReview = false
    var showAddScore = false

    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared, game: Game) {
        self.interactor = interactor
        self.game = game
    }
    
    func loadGameDetails() async {
        do {
            (favorite, reviews, scores) = try await interactor.getGameDetails(id: game.id)
        } catch {
            self.errorMsg = error.localizedDescription
            self.showAlert.toggle()
            print(error.localizedDescription)
        }
    }
    
    func useFavorite() {
        Task {
            do {
                if favorite {
                    try await interactor.removeFavoriteGame(id: game.id)
                } else {
                    try await interactor.addFavoriteGame(id: game.id)
                }
                favorite.toggle()
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
}
