import SwiftUI
import SwiftData

@Observable
final class SearchVM {
    let interactor: DataInteractor
    
    var search: String = ""
    var games: [Game] = []
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    func searchGame() {
        Task {
            do {
                if !search.isEmpty {
                    games = try await interactor.searchGame(name: search)
                } else {
                    games.removeAll()
                }
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func saveGameSearch(game: Game, context: ModelContext) throws {
        let id = game.id
        let query = FetchDescriptor<GameModel>(predicate: #Predicate { $0.id == id })
        if let fetch = try context.fetch(query).first {
            return
        } else {
            let newGame = GameModel(id: game.id,
                                    name: game.name,
                                    desc: game.description,
                                    console: game.console.rawValue,
                                    genre: game.genre.rawValue,
                                    releaseDate: game.releaseDate,
                                    added: .now)
            context.insert(newGame)
        }
    }
    
    func deleteGameSearch(game: Game? = nil, context: ModelContext) throws {
        if let game {
            let id = game.id
            let query = FetchDescriptor<GameModel>(predicate: #Predicate { $0.id == id })
            if let fetch = try context.fetch(query).first {
                context.delete(fetch)
            }
        } else {
            let query = FetchDescriptor<GameModel>()
            let allGames = try context.fetch(query)
            for game in allGames {
                context.delete(game)
            }
        }
    }
}
