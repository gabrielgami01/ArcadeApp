import Foundation

let desa = URL(string: "http://localhost:8080")!
let proxy = URL(string: "https://3cf1-81-32-229-229.ngrok-free.app")!

let api = desa.appending(path: "api")

extension URL {
    static let users = api.appending(path: "users")
    static let createUser = users.appending(path: "create")
    static let loginJWT = users.appending(path: "login")
    static let refreshJWT = users.appending(path: "refreshJWT")
    static let getUserInfo = users.appending(path: "userInfo")
    static let updateUserAbout = users.appending(path: "updateAbout")
    static let updateUserAvatar = users.appending(path: "updateAvatar")
    
    private static let games = api.appending(path: "games")
    static func getAllGames(page: Int) -> URL {
        games.appending(path: "list").appending(queryItems: [.page(page), .per()])
    }
    static func getGamesByConsole(name: String, page: Int) -> URL {
        games.appending(path: "byConsole").appending(queryItems: [.console(name), .page(page), .per()])
    }
    static let getFeaturedGames = games.appending(path: "featured")
    static func searchGame(name: String, page: Int) -> URL {
        games.appending(path: "search").appending(queryItems: [.game(name), .page(page), .per()])
    }
    static let favorites = games.appending(path: "favorites")
    static let getUserFavoriteGames = favorites.appending(path: "list")
    static let addFavoriteGame = favorites.appending(path: "addGame")
    static let deleteFavoriteGame = favorites.appending(path: "deleteGame")
    static func isFavoriteGame(id: UUID) -> URL {
        favorites.appending(path: "isFavorite").appending(path: id.uuidString)
    }
    
    static let reviews = api.appending(path: "reviews")
    static func getGameReviews(id: UUID) -> URL {
        reviews.appending(path: "list").appending(path: id.uuidString)
    }
    static let addReview = reviews.appending(path: "add")
    
    static let scores = api.appending(path: "scores")
    static func getGameScores(id: UUID) -> URL {
        scores.appending(path: "list").appending(path: id.uuidString)
    }
    static let addScore = scores.appending(path: "add")
   
    static let challenges = api.appending(path: "challenges")
    static let getAllChallenges = challenges.appending(path: "list")
    static func getChallengesByType(type: String) -> URL {
        challenges.appending(path: "byType").appending(queryItems: [.type(type)])
    }
    static let getCompletedChallenges = challenges.appending(path: "listCompleted")
    static func isChallengeCompleted(id: UUID) -> URL {
        challenges.appending(path: "isCompleted").appending(path: id.uuidString)
    }
    static let emblems = challenges.appending(path: "emblems")
    static let getActiveEmblems = emblems.appending(path: "listActive")
    static let addEmblem = emblems.appending(path: "add")
    static let deleteEmblem = emblems.appending(path: "delete")
    
    static let rankings = api.appending(path: "rankings")
    static func getGameRanking(id: UUID, page: Int) -> URL {
        rankings.appending(path: "list").appending(path: id.uuidString).appending(queryItems: [.page(page), .per()])
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
