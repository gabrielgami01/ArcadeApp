import SwiftUI
import SwiftData
import Combine

@Observable
final class SearchVM {
    let repository: RepositoryProtocol
    
    private var subscribers = Set<AnyCancellable>()
    let searchPublisher = PassthroughSubject<String, Never>()
    var inputText: String = "" {
        didSet {
            searchPublisher.send(inputText)
        }
    }
    var searchText: String = "" {
        didSet {
            Task { await searchGame() }
        }
    }
    
    var games: [Game] = []
    
    var showError = false
    
    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
        searchPublisher
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [self] text in
                searchText = text
            }
            .store(in: &subscribers)
    }
    
    func searchGame() async {
        do {
            let games = try await repository.getGamesByName(searchText)
            await MainActor.run {
                self.games = games
            }
        } catch {
            await MainActor.run {
                showError = true
            }
            print(error.localizedDescription)
        }
    }
    
    func saveGameSearch(game: Game, context: ModelContext) throws {
        let id = game.id
        let query = FetchDescriptor<GameModel>(predicate: #Predicate { $0.id == id })
        
        if let _ = try context.fetch(query).first {
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
