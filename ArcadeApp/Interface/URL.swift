import Foundation

let desa = URL(string: "http://localhost:8080")!
let proxy = URL(string: "https://a6cf-83-53-211-97.ngrok-free.app")!

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
    static func searchGame(name: String) -> URL {
        games.appending(path: "search").appending(queryItems: [.game(name)])
    }
    static let favorites = games.appending(path: "favorites")
    static let getUserFavoriteGames = favorites.appending(path: "list")
    static let addFavoriteGame = favorites.appending(path: "add")
    static func deleteFavoriteGame(id: UUID) -> URL {
        favorites.appending(path: "delete").appending(path: id.uuidString)
    }
    static func isFavoriteGame(id: UUID) -> URL {
        favorites.appending(path: "isFavorite").appending(path: id.uuidString)
    }
    
    static let reviews = api.appending(path: "reviews")
    static func getGameReviews(id: UUID) -> URL {
        reviews.appending(path: "listByGame").appending(path: id.uuidString)
    }
    static let addReview = reviews.appending(path: "add")
    
    static let scores = api.appending(path: "scores")
    static func getGameScores(id: UUID) -> URL {
        scores.appending(path: "list").appending(path: id.uuidString)
    }
    static let addScore = scores.appending(path: "add")
   
    static let challenges = api.appending(path: "challenges")
    static let getChallenges = challenges.appending(path: "list")
    
    static let emblems = api.appending(path: "emblems")
    static let getActiveUserEmblems = emblems.appending(path: "listActive")
    static func getUserEmblems(id: UUID) -> URL {
        emblems.appending(path: "listActive").appending(path: id.uuidString)
    }
    static let addEmblem = emblems.appending(path: "add")
    static func deleteEmblem(challengeID: UUID) -> URL {
        emblems.appending(path: "delete").appending(path: challengeID.uuidString)
    }
    
    static let rankings = api.appending(path: "rankings")
    static func getGameRanking(id: UUID, page: Int) -> URL {
        rankings.appending(path: "list").appending(path: id.uuidString).appending(queryItems: [.page(page), .per()])
    }
    
    static let listFollowing = users.appending(path: "listFollowing")
    static let listFollowers = users.appending(path: "listFollowers")
    static let followUser = users.appending(path: "follow")
    static func unfollowUser(id: UUID) -> URL {
        users.appending(path: "unfollow").appending(path: id.uuidString)
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
