import Foundation

let desa = URL(string: "http://localhost:8080")!
let proxy = URL(string: "https://0e5d-83-53-211-97.ngrok-free.app")!

let api = desa.appending(path: "api")


extension URL {
    private static let users = api.appending(path: "users")
    static let createUser = users.appending(path: "create")
    static let loginJWT = users.appending(path: "login")
    static let refreshJWT = users.appending(path: "refreshJWT")
    static let updateUserAbout = users.appending(path: "updateAbout")
    static let updateUserAvatar = users.appending(path: "updateAvatar")
    
    private static let games = api.appending(path: "games")
    static func getAllGames(page: Int) -> URL {
        games.appending(queryItems: [.page(page), .per(), .language()])
    }
    static func getGamesByConsole(_ console: String, page: Int) -> URL {
        games.appending(path: "byConsole").appending(queryItems: [.console(console), .page(page), .per(), .language()])
    }
    static func getGamesByName(_ name: String) -> URL {
        games.appending(path: "byName").appending(queryItems: [.game(name), .language()])
    }
    static let getFeaturedGames = games.appending(path: "featured").appending(queryItems: [.language()])
    
    private static let favorites = api.appending(path: "favorites")
    static let getFavoriteGames = favorites.appending(queryItems: [.language()])
    static func isFavoriteGame(id: UUID) -> URL {
        favorites.appending(path: id.uuidString)
    }
    static func addFavoriteGame(id: UUID) -> URL {
        favorites.appending(path: id.uuidString)
    }
    static func deleteFavoriteGame(id: UUID) -> URL {
        favorites.appending(path: id.uuidString)
    }
    
    private static let reviews = api.appending(path: "reviews")
    static func getGameReviews(id: UUID) -> URL {
        reviews.appending(path: id.uuidString)
    }
    static let addReview = reviews
    
    private static let scores = api.appending(path: "scores")
    static func getGameScores(id: UUID) -> URL {
        scores.appending(path: id.uuidString)
    }
    static func getGameRanking(id: UUID) -> URL {
        scores.appending(path: "ranking").appending(path: id.uuidString)
    }
    static let addScore = scores
    
    private static let session = api.appending(path: "sessions")
    static func getGameSessions(id: UUID) -> URL {
        session.appending(path: id.uuidString).appending(queryItems: [.language()])
    }
    static let getActiveSession = session.appending(path: "active").appending(queryItems: [.language()])
    static let getFollowingActiveSessions = session.appending(path: "following").appending(queryItems: [.language()])
    static func startSession(gameID: UUID) -> URL {
        session.appending(path: gameID.uuidString)
    }
    static func endSession(id: UUID) -> URL {
        session.appending(path: id.uuidString)
    }
   
    private static let challenges = api.appending(path: "challenges")
    static let getChallenges = challenges.appending(queryItems: [.language()])
    
    private static let badges = api.appending(path: "badges")
    static let getBadges = badges
    static func getFeaturedBadges(userID: UUID) -> URL {
        badges.appending(path: userID.uuidString)
    }
    static let highlightBadge = badges.appending(path: "highlight")
    static func unhighlightBadge(id: UUID) -> URL {
        badges.appending(path: "unhighlight").appending(path: id.uuidString)
    }
    
    private static let connections = api.appending(path: "connections")
    static let listFollowing = connections.appending(path: "following")
    static let listFollowers = connections.appending(path: "followers")
    static func followUser(id: UUID) -> URL {
        users.appending(path: id.uuidString)
    }
    static func unfollowUser(id: UUID) -> URL {
        users.appending(path: id.uuidString)
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
        URLQueryItem(name: "name", value: name)
    }
    static func console(_ name: String) -> URLQueryItem {
        URLQueryItem(name: "console", value: name)
    }
    static func language() -> URLQueryItem {
        if let lang = Locale.current.language.languageCode {
            URLQueryItem(name: "lang", value: lang.identifier)
        } else {
            URLQueryItem(name: "lang", value: "en")
        }
    }
}
