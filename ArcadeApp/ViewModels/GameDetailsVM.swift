import Foundation

@Observable
final class GameDetailsVM {
    let interactor: DataInteractor
    
    var favorite = false
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    func loadGameDetails(id: UUID) {
        Task {
            do {
                self.favorite = try await interactor.isFavoriteGame(id: id)
                print(favorite)
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
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
