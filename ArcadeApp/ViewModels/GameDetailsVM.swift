import Foundation

@Observable
final class GameDetailsVM {
    let interactor: DataInteractor
    
    var favorite = false
    var reviews: [Review] = []
    
    var showAddReview = false

    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    func loadGameDetails(id: UUID) async {
        do {
            self.favorite = try await interactor.isFavoriteGame(id: id)
            self.reviews = try await interactor.getGameReviews(id: id)
        } catch {
            self.errorMsg = error.localizedDescription
            self.showAlert.toggle()
            print(error.localizedDescription)
        }
    }
    
    func useFavorite(gameID: UUID) {
        Task {
            do {
                if favorite {
                    try await interactor.removeFavoriteGame(id: gameID)
                } else {
                    try await interactor.addFavoriteGame(id: gameID)
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
