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
        let name = game.name
        
        let newGame = GameModel(id: id, name: name, image: nil)
        
        context.insert(newGame)
    }
}
