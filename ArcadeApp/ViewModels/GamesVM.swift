import SwiftUI

@Observable
final class GamesVM {
    let repository: RepositoryProtocol
    
    var featured: [Game] = []
    var favorites: [Game] = []
    
    var selectedGame: Game? = nil
    
    var games: [Game] = []
    var page = 1
    @ObservationIgnored var gamesCache: [Console: [Game]] = [:]
    @ObservationIgnored var pageCache: [Console: Int] = [:]
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
    
    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
        if SecManager.shared.isLogged {
            Task(priority: .high) {
                await getFeaturedFavoriteGames()
                await getGames()
            }
        }
        NotificationCenter.default.addObserver(forName: .login, object: nil, queue: .main) { [self] _ in
            Task(priority: .high) {
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
            let (featured, favorites) = try await repository.getFeaturedFavoriteGames()
            await MainActor.run {
                self.featured = featured
                self.favorites = favorites
            }
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func getGames() async {
        do {
            if activeConsole == .all {
                let games = try await repository.getAllGames(page: page)
                await MainActor.run {
                    self.games += games
                }
            } else {
                let games = try await repository.getGamesByConsole(activeConsole, page: page)
                await MainActor.run {
                    self.games += games
                }
            }
            gamesCache[activeConsole] = games
            pageCache[activeConsole] = page
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
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
