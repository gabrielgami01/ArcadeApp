import SwiftUI
import SwiftData

@Observable
final class SearchVM {
    let interactor: DataInteractor
    
    var search: String = "" {
        didSet {
            page = 1
        }
    }
    var games: [Game] = []
    
    var page = 1
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    func searchGame(name: String) {
        Task {
            do {
                self.games = try await interactor.searchGame(name: name, page: page)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveGameSearch(game: Game, context: ModelContext) throws {
        let id = game.id
        let query = FetchDescriptor<GameModel>(predicate:
            #Predicate { $0.id == id }
        )
        
        if let fetch = try context.fetch(query).first {
            
        } else {
            let newGame = GameModel(id: game.id, name: game.name, image: nil)
            context.insert(newGame)
        }
        
        
       
    }
    
    func deleteGameSearch(game: GameModel? = nil, context: ModelContext) throws {
        if let game = game {
            // Eliminar un elemento específico
            let id = game.id
            let query = FetchDescriptor<GameModel>(predicate:
                #Predicate { $0.id == id }
            )
            if let fetch = try context.fetch(query).first {
                context.delete(fetch)
            }
        } else {
            // Eliminar todos los elementos
            let query = FetchDescriptor<GameModel>()
            let allGames = try context.fetch(query)
            for game in allGames {
                context.delete(game)
            }
        }
    }
}
