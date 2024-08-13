import Foundation

let desa = URL(string: "http://localhost:8080")!
let proxy = URL(string: "https://b9a6-81-32-237-227.ngrok-free.app")!

let api = desa.appending(path: "api")

extension URL {
    static let users = api.appending(path: "users")
    static let createUser = users.appending(path: "create")
    static let loginJWT = users.appending(path: "loginJWT")
    static let refreshJWT = users.appending(path: "refreshJWT")
    static let getUserInfo = users.appending(path: "userInfo")
    static let editUserAbout = users.appending(path: "updateAbout")
    
    private static let games = api.appending(path: "games")
    static func getAllGames(page: Int) -> URL {
        games.appending(queryItems: [.page(page), .per()])
    }
    static let getFeaturedGames = games.appending(path: "featured")
    static func searchGame(name: String, page: Int) -> URL {
        games.appending(path: "search").appending(queryItems: [.game(name), .page(page), .per()])
    }
    static func getGamesByConsole(name: String, page: Int) -> URL {
        games.appending(path: "byConsole").appending(queryItems: [.console(name), .page(page), .per()])
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
   
    static let challenges = api.appending(path: "challenges")
    static func getAllChallenges(page: Int) -> URL {
        challenges.appending(queryItems: [.page(page), .per()])
    }
    static func getChallengesByType(type: String, page: Int) -> URL {
        challenges.appending(path: "byType").appending(queryItems: [.type(type), .page(page), .per()])
    }
    static func isChallengeCompleted(id: UUID) -> URL {
        challenges.appending(path: id.uuidString)
    }
}

extension URLQueryItem {
    static func page(_ num: Int) -> URLQueryItem {
        URLQueryItem(name: "page", value: "\(num)")
    }
    static func per(_ num: Int = 20) -> URLQueryItem {
        URLQueryItem(name: "per", value: "\(num)")
    }
    static func game(_ name: String) -> URLQueryItem {
        URLQueryItem(name: "game", value: name)
    }
    static func console(_ name: String) -> URLQueryItem {
        URLQueryItem(name: "console", value: name)
    }
    static func type(_ name: String) -> URLQueryItem {
        URLQueryItem(name: "type", value: name)
    }
    
}
