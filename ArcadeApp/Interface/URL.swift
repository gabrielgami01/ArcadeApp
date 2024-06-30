import Foundation

let desa = URL(string: "http://localhost:8080/api")!

let api = desa

extension URL {
    static let createUser = api.appending(path: "users").appending(path: "create")
    static let loginJWT = api.appending(path: "users").appending(path: "loginJWT")
    
    static let getConsoles = api.appending(path: "consoles")
    static let getGenres = api.appending(path: "genres")
    
    private static let games = api.appending(path: "games")
    static let getFeaturedGames = games.appending(path: "featured")
    static func getGamesByConsole(id: UUID) -> URL {
        games.appending(path: "byConsole").appending(path: id.uuidString)
    }
    static func getGamesByGenre(id: UUID) -> URL {
        games.appending(path: "byGenre").appending(path: id.uuidString)
    }
    
    static let getFavoriteGames = games.appending(path: "favorites")
    static func useFavoriteGame(id: UUID) -> URL {
        getFavoriteGames.appending(path: id.uuidString)
    }
}
