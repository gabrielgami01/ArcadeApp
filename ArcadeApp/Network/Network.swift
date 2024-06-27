import Foundation
import ACNetwork

protocol DataInteractor {
    func createUser(user: CreateUserDTO) async throws
    func loginJWT(user: String, pass: String) async throws
    
    func getConsolesGenres() async throws -> (consoles: [Console], genres: [Genre])
    func getGamesByConsole(id: UUID) async throws -> [Game]
    func getGamesByGenre(id: UUID) async throws -> [Game]
}

struct Network: DataInteractor, NetworkJSONInteractor {
    static let shared = Network()
    
    func getToken() -> String? {
        guard let token = SecKeyStore.shared.readKey(label: "token") else {
            return nil
        }
        return String(data: token, encoding: .utf8)
    }
    
    //USERS
    func createUser(user: CreateUserDTO) async throws {
        var request: URLRequest = .post(url: .createUser, post: user)
        request.setValue(SecManager.shared.appAPIKEY, forHTTPHeaderField: "App-APIKey")
        
        try await post(request: request, status: 201)
    }
    func loginJWT(user: String, pass: String) async throws {
        let token = "\(user):\(pass)".data(using: .utf8)?.base64EncodedString()
        let accessToken = try await getJSON(request: .get(url: .loginJWT, token: token, authType: .basic), type: TokenDTO.self)
        SecKeyStore.shared.storeKey(key: Data(accessToken.token.utf8), label: "token")
    }
    //END USERS
    
    //SEARCH
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
    //END SEARCH
}
