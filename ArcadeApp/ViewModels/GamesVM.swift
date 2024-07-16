import SwiftUI

@Observable
final class GamesVM {
    let interactor: DataInteractor
    
    var featured: [Game] = []
    var favorites: [Game] = []
    
    var games: [Game] = []
    var selectedGame: Game? = nil
    var homeType: HomeScrollType = .featured
    
    var errorMsg = ""
    var showAlert = false
    
    var activeConsole: Console = .all {
        didSet {
            activeConsole != oldValue ? games.removeAll() : nil
            page = 1
        }
    }
    
    var page = 1
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        if SecManager.shared.isLogged {
            getFeaturedFavoriteGames()
            getGames()
        }
        NotificationCenter.default.addObserver(forName: .login, object: nil, queue: .main) { _ in
            self.getFeaturedFavoriteGames()
            self.getGames()
        }
    }
    
    func getGames(console: Console = .all) {
        Task {
            do {
                if console == .all {
                    self.games += try await interactor.getAllGames(page: page)
                } else {
                    self.games += try await interactor.getGamesByConsole(name: console.rawValue, page: page)
                }
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    
    func getFeaturedFavoriteGames() {
        Task {
            do {
                (featured, favorites) = try await interactor.getFeaturedFavoriteGames()
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func isLastItem(game: Game) {
        if games.last?.id == game.id {
            page += 1
            getGames(console: activeConsole)
        }
    }
    
}
