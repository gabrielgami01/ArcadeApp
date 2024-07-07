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
    static func searchGame(name: String) -> URL {
        games.appending(path: "search").appending(queryItems: [.game(name: name)])
    }
    
    static let favoriteGames = games.appending(path: "favorites")
    static func isFavoriteGame(id: UUID) -> URL {
        favoriteGames.appending(path: id.uuidString)
    }
    
    static let reviews = api.appending(path: "reviews")
    static func getGameReviews(id: UUID) -> URL {
        reviews.appending(path: id.uuidString)
    }
   
}

extension URLQueryItem {
    static func game(name: String) -> URLQueryItem {
        URLQueryItem(name: "gameName", value: name)
    }
}
