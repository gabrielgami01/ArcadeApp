import Foundation
import ACNetwork

protocol SearchInteractorProtocol {
    func getConsolesGenres() async throws -> (consoles: [Console], genres: [Genre])
    func getGamesByConsole(id: UUID) async throws -> [Game]
    func getGamesByGenre(id: UUID) async throws -> [Game]
}

struct SearchInteractor: SearchInteractorProtocol, NetworkJSONInteractor {
    static let shared = SearchInteractor()
    
    func getToken() -> String? {
        guard let token = SecKeyStore.shared.readKey(label: "token") else {
            return nil
        }
        return String(data: token, encoding: .utf8)
    }
    
    func getConsolesGenres() async throws -> (consoles: [Console], genres: [Genre]) {
        async let consolesRequest = getJSON(request: .get(url: .getConsoles, token: getToken()), type: [Console].self)
        async let genresRequest = getJSON(request: .get(url: .getGenres, token: getToken()), type: [Genre].self)
        
        return try await (consolesRequest, genresRequest)
    }
    
    func getGamesByConsole(id: UUID) async throws -> [Game] {
        try await getJSON(request: .get(url: .getGamesByConsole(id: id), token: getToken()), type: [GameDTO].self).map(\.toGame)
    }
    
    func getGamesByGenre(id: UUID) async throws -> [Game] {
        try await getJSON(request: .get(url: .getGamesByGenre(id: id), token: getToken()), type: [GameDTO].self).map(\.toGame)
    }
}
