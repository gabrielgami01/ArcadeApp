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
    
    var showAddReview = false

    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared, game: Game) {
        self.interactor = interactor
        self.game = game
    }
    
    func loadGameDetails() async {
        do {
            self.favorite = try await interactor.isFavoriteGame(id: game.id)
            self.reviews = try await interactor.getGameReviews(id: game.id)
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
