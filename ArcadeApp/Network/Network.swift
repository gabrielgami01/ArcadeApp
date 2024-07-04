import Foundation
import ACNetwork

protocol DataInteractor {
    func createUser(user: CreateUserDTO) async throws
    func loginJWT(user: String, pass: String) async throws
    
    func getConsolesGenres() async throws -> (consoles: [Console], genres: [Genre])
    func getGamesByMaster(master: Master) async throws -> [Game]
    func searchGame(name: String) async throws -> [Game]
    
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game]) 
    func isFavoriteGame(id: UUID) async throws -> Bool
    func addFavoriteGame(id: UUID) async throws
    func removeFavoriteGame(id: UUID) async throws
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
        NotificationCenter.default.post(name: .login, object: nil)
    }
    //END USERS
    
    //SEARCH
    func getConsolesGenres() async throws -> (consoles: [Console], genres: [Genre]) {
        async let consolesRequest = getJSON(request: .get(url: .getConsoles, token: getToken()), type: [Console].self)
        async let genresRequest = getJSON(request: .get(url: .getGenres, token: getToken()), type: [Genre].self)
        
        return try await (consolesRequest, genresRequest)
    }
    
    func getGamesByMaster(master: Master) async throws -> [Game] {
        return if master is Console {
            try await getJSON(request: .get(url: .getGamesByConsole(id: master.id), token: getToken()), type: [GameDTO].self).map(\.toGame)
        } else {
            try await getJSON(request: .get(url: .getGamesByGenre(id: master.id), token: getToken()), type: [GameDTO].self).map(\.toGame)
        }
    }
    
    func searchGame(name: String) async throws -> [Game] {
        try await getJSON(request: .get(url: .searchGame(name: name), token: getToken()), type: [GameDTO].self).map(\.toGame)
    }

    //END SEARCH
    
    //HOME
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game]) {
        async let featuredRequest = getJSON(request: .get(url: .getFeaturedGames, token: getToken()), type: [GameDTO].self).map(\.toGame)
        async let favoritesRequest = getJSON(request: .get(url: .favoriteGames, token: getToken()), type: [GameDTO].self).map(\.toGame)
        
        return try await (featuredRequest, favoritesRequest)
    }
    //HOME
    
    func isFavoriteGame(id: UUID) async throws -> Bool {
        try await getJSON(request: .get(url: .isFavoriteGame(id: id), token: getToken()), type: Bool.self)
    }
    
    func addFavoriteGame(id: UUID) async throws {
        let favoriteGameDTO = FavoriteGameDTO(id: id)
        try await post(request: .post(url: .favoriteGames, post: favoriteGameDTO, token: getToken()), status: 201)
    }
    
    func removeFavoriteGame(id: UUID) async throws {
        let favoriteGameDTO = FavoriteGameDTO(id: id)
        try await post(request: .post(url: .favoriteGames, post: favoriteGameDTO, method: .delete, token: getToken()))
    }
}
