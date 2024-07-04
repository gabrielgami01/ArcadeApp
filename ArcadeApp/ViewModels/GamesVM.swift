import SwiftUI

@Observable
final class GamesVM {
    let interactor: DataInteractor
    
    var featured: [Game] = []
    var favorites: [Game] = []
    
    var consoles: [Console] = []
    var genres: [Genre] = []

    var games: [Game] = []
    var selectedGame: Game? = nil
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        if SecManager.shared.isLogged {
            Task {
                await getFeaturedFavoriteGames()
                await getConsolesGenres()
            }
        }
        NotificationCenter.default.addObserver(forName: .login, object: nil, queue: .main) { _ in
            Task {
                await self.getFeaturedFavoriteGames()
                await self.getConsolesGenres()
            }
        }
    }
    
    func getFeaturedFavoriteGames() async {
        do {
            (featured, favorites) = try await interactor.getFeaturedFavoriteGames()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getConsolesGenres() async {
        do {
            (self.consoles, self.genres) = try await interactor.getConsolesGenres()
        } catch {
            self.errorMsg = error.localizedDescription
            self.showAlert.toggle()
            print(error.localizedDescription)
        }
    }
    
    func getGamesByMaster(master: Master) async {
        do {
            self.games = try await interactor.getGamesByMaster(master: master)
        } catch {
            self.errorMsg = error.localizedDescription
            self.showAlert.toggle()
            print(error.localizedDescription)
        }
    }
}
