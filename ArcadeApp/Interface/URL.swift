import Foundation

let desa = URL(string: "http://localhost:8080/api")!
let proxy = URL(string: "https://b259-81-32-237-227.ngrok-free.app/api")!

let api = proxy

extension URL {
    static let createUser = api.appending(path: "users").appending(path: "create")
    static let loginJWT = api.appending(path: "users").appending(path: "loginJWT")
    
    private static let games = api.appending(path: "games")
    static func getAllGames(page: Int) -> URL {
        games.appending(queryItems: [.page(num: page), .per()])
    }
    static let getFeaturedGames = games.appending(path: "featured")
    static func searchGame(name: String, page: Int) -> URL {
        games.appending(path: "search").appending(queryItems: [.game(name: name), .page(num: page), .per()])
    }
    static func getGamesByConsole(name: String, page: Int) -> URL {
        games.appending(path: "byConsole").appending(queryItems: [.console(name: name), .page(num: page), .per()])
    }
    
    static let favoriteGames = games.appending(path: "favorites")
    static func isFavoriteGame(id: UUID) -> URL {
        favoriteGames.appending(path: id.uuidString)
    }
    
    static let reviews = api.appending(path: "reviews")
    static func getGameReviews(id: UUID) -> URL {
        reviews.appending(path: id.uuidString)
    }
    
    static let scores = api.appending(path: "scores")
    static func getGameScores(id: UUID) -> URL {
        scores.appending(path: id.uuidString)
    }
   
}

extension URLQueryItem {
    static func page(num: Int) -> URLQueryItem {
        URLQueryItem(name: "page", value: "\(num)")
    }
    static func per(num: Int = 20) -> URLQueryItem {
        URLQueryItem(name: "per", value: "\(num)")
    }
    static func game(name: String) -> URLQueryItem {
        URLQueryItem(name: "game", value: name)
    }
    static func console(name: String) -> URLQueryItem {
        URLQueryItem(name: "console", value: name)
    }
    
}
