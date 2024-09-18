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
                    Task { await getGames() }
                }
             }
        }
    }
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        if SecManager.shared.isLogged {
            Task {
                await getFeaturedFavoriteGames()
                await getGames()
            }
        }
        NotificationCenter.default.addObserver(forName: .login, object: nil, queue: .main) { [self] _ in
            Task {
                await getFeaturedFavoriteGames()
                await getGames()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .login, object: nil)
    }
    
    func getFeaturedFavoriteGames() async {
        do {
            (featured, favorites) = try await interactor.getFeaturedFavoriteGames()
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
        }
    }
    
    func getGames() async {
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
    
    func isLastItem(_ game: Game) {
        if games.last?.id == game.id {
            page += 1
            pageCache[activeConsole] = page
            Task { await getGames() }
        }
    }
    
    func toggleFavoriteGame(game: Game, favorite: Bool) {
        if favorite {
            favorites.append(game)
        } else {
            favorites.removeAll { $0.id == game.id }
        }
    }
    
}
