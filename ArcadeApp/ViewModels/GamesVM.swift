import SwiftUI

@Observable
final class GamesVM {
    let interactor: DataInteractor
    
    var featured: [Game] = []
    var favorites: [Game] = []
    
    var selectedGame: Game? = nil
    
    var games: [Game] = []
    var page = 1
    var gamesCache: [Console: [Game]] = [:]
    var pageCache: [Console: Int] = [:]
    var activeConsole: Console = .all {
        didSet {
            if activeConsole != oldValue {
                games = gamesCache[activeConsole] ?? []
                page = pageCache[activeConsole] ?? 1
                
                if games.isEmpty {
                    getGames()
                } 
             }
        }
    }
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        if SecManager.shared.isLogged {
            getFeaturedFavoriteGames()
            getGames()
        }
        NotificationCenter.default.addObserver(forName: .login, object: nil, queue: .main) { [self] _ in
            getFeaturedFavoriteGames()
            getGames()
        }
        NotificationCenter.default.addObserver(forName: .favorite, object: nil, queue: .main) { [self] _ in
           getFeaturedFavoriteGames()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .login, object: nil)
        NotificationCenter.default.removeObserver(self, name: .favorite, object: nil)
    }
    
    func getFeaturedFavoriteGames() {
        Task {
            do {
                (featured, favorites) = try await interactor.getFeaturedFavoriteGames()
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func getGames() {
        Task {
            do {
                var newGames: [Game] = []
                if activeConsole == .all {
                    newGames = try await interactor.getAllGames(page: page)
                } else {
                    newGames = try await interactor.getGamesByConsole(activeConsole, page: page)
                }
                
                games += newGames
                
                gamesCache[activeConsole] = games
                pageCache[activeConsole] = page
                
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func isLastItem(_ game: Game) {
        if games.last?.id == game.id {
            page += 1
            pageCache[activeConsole] = page
            getGames()
        }
    }
    
}
