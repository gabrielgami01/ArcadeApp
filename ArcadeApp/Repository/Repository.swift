import Foundation

protocol RepositoryProtocol {
    func register(user: CreateUserDTO) async throws
    func login(user: String, pass: String) async throws -> User
    func refreshJWT() async throws -> User
    func updateUserAbout(_ updateUserDTO: UpdateUserDTO) async throws
    func updateUserAvatar(_ updateUserDTO: UpdateUserDTO) async throws
    func getAllGames(page: Int) async throws -> [Game]
    func getGamesByConsole(_ console: Console, page: Int) async throws -> [Game]
    func getGamesByName(_ name: String) async throws -> [Game]
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game])
    func addFavoriteGame(id: UUID) async throws
    func deleteFavoriteGame(id: UUID) async throws
    func getGameDetails(id: UUID) async throws -> (favorite: Bool, reviews: [Review], scores: [Score], sessions: [Session])
    func addReview(_ review: CreateReviewDTO) async throws
    func addScore(_ score: CreateScoreDTO) async throws
    func getChallenges() async throws -> [Challenge]
    func getGameRanking(id: UUID, page: Int) async throws -> [RankingScore]
    func getFollowingFollowers() async throws -> (following: [UserConnections], followers: [UserConnections])
    func followUser(id: UUID) async throws
    func unfollowUser(id: UUID) async throws
    func startSession(gameID: UUID) async throws
    func endSession(id: UUID) async throws
    func getActiveSession() async throws -> Session
    func getFollowingActiveSession() async throws -> [Session]
}

struct Repository: RepositoryProtocol, JSONService {
    
    let session: URLSession
    
    static let shared = Repository()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getToken() -> String? {
        guard let token = SecKeyStore.shared.readKey(label: "token") else {
            return nil
        }
        return String(data: token, encoding: .utf8)
    }
    
    func register(user: CreateUserDTO) async throws {
        var request: URLRequest = .send(url: .createUser, data: user, method: .post)
        request.setValue(SecManager.shared.appAPIKEY, forHTTPHeaderField: "App-APIKey")
        
        try await send(request: request, status: 201)
    }
    
    func login(user: String, pass: String) async throws -> User {
        let token = "\(user):\(pass)".data(using: .utf8)?.base64EncodedString()
        let loginDTO = try await fetchJSON(request: .get(url: .loginJWT, token: token, authType: .basic), type: LoginDTO.self)
        SecKeyStore.shared.storeKey(key: Data(loginDTO.token.utf8), label: "token")
        
        return loginDTO.user
    }
    
    func refreshJWT() async throws -> User {
        let loginDTO = try await fetchJSON(request: .get(url: .refreshJWT, token: getToken()), type: LoginDTO.self)
        SecKeyStore.shared.storeKey(key: Data(loginDTO.token.utf8), label: "token")
       
        return loginDTO.user
    }
    
    func updateUserAbout(_ updateUserDTO: UpdateUserDTO) async throws {
        try await send(request: .send(url: .updateUserAbout, data: updateUserDTO, method: .patch, token: getToken()), status: 200)
    }
    
    func updateUserAvatar(_ updateUserDTO: UpdateUserDTO) async throws {
        try await send(request: .send(url: .updateUserAvatar, data: updateUserDTO, method: .patch, token: getToken()), status: 200)
    }
    
    func getAllGames(page: Int) async throws -> [Game] {
        try await fetchJSON(request: .get(url: .getAllGames(page: page), token: getToken()), type: GamePageDTO.self).items
    }
    
    func getGamesByConsole(_ console: Console, page: Int) async throws -> [Game] {
        try await fetchJSON(request: .get(url: .getGamesByConsole(console.rawValue, page: page), token: getToken()), type: GamePageDTO.self).items
    }
    
    func getGamesByName(_ name: String) async throws -> [Game] {
        try await fetchJSON(request: .get(url: .getGamesByName(name), token: getToken()), type: [Game].self)
    }
    
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game]) {
        async let featuredRequest = fetchJSON(request: .get(url: .getFeaturedGames, token: getToken()), type: [Game].self)
        async let favoritesRequest = fetchJSON(request: .get(url: .getFavoriteGames, token: getToken()), type: [Game].self)
        
        return try await (featuredRequest, favoritesRequest)
    }

    func getGameDetails(id: UUID) async throws -> (favorite: Bool, reviews: [Review], scores: [Score], sessions: [Session]) {
        async let favoriteRequest = fetchJSON(request: .get(url: .isFavoriteGame(id: id), token: getToken()), type: Bool.self)
        async let reviewsRequest = fetchJSON(request: .get(url: .getGameReviews(id: id), token: getToken()), type: [Review].self)
        async let scoresRequest  = fetchJSON(request: .get(url: .getGameScores(id: id), token: getToken()), type: [Score].self)
        async let sessionsRequest = fetchJSON(request: .get(url: .getGameSessions(id: id), token: getToken()), type: [Session].self)
        
        return try await (favoriteRequest, reviewsRequest, scoresRequest, sessionsRequest)
    }
    
    func addFavoriteGame(id: UUID) async throws {
        try await send(request: .send(url: .addFavoriteGame(id: id), data: "", method: .post, token: getToken()), status: 201)
    }
    
    func deleteFavoriteGame(id: UUID) async throws {
        try await send(request: .send(url: .deleteFavoriteGame(id: id), data: "", method: .delete, token: getToken()), status: 200)
    }

    func addReview(_ review: CreateReviewDTO) async throws {
        try await send(request: .send(url: .addReview, data: review, method: .post, token: getToken()), status: 201)
    }
    
   
    func addScore(_ score: CreateScoreDTO) async throws {
        try await send(request: .send(url: .addScore, data: score, method: .post, token: getToken()), status: 201)
    }

    func getChallenges() async throws -> [Challenge] {
        try await fetchJSON(request: .get(url: .getChallenges, token: getToken()), type: [Challenge].self)
    }

    func getGameRanking(id: UUID, page: Int) async throws -> [RankingScore] {
        try await fetchJSON(request: .get(url: .getGameRanking(id: id), token: getToken()), type: [RankingScore].self)
    }

    func getFollowingFollowers() async throws -> (following: [UserConnections], followers: [UserConnections]) {
        async let followingRequest = fetchJSON(request: .get(url: .listFollowing, token: getToken()), type: [UserConnections].self)
        async let followersRequest = fetchJSON(request: .get(url: .listFollowers, token: getToken()), type: [UserConnections].self)
        
        return try await(followingRequest, followersRequest)
    }
    
    func followUser(id: UUID) async throws {
        try await send(request: .send(url: .followUser(id: id), data: "", method: .post, token: getToken()), status: 201)
    }
    
    func unfollowUser(id: UUID) async throws {
        try await send(request: .send(url: .unfollowUser(id: id), data: "", method: .delete, token: getToken()), status: 200)
    }
    
    func getActiveSession() async throws -> Session {
        try await fetchJSON(request: .get(url: .getActiveSession, token: getToken()), type: Session.self)
    }
    
    func getFollowingActiveSession() async throws -> [Session] {
        try await fetchJSON(request: .get(url: .getFollowingActiveSessions, token: getToken()), type: [Session].self)
    }

    func startSession(gameID: UUID) async throws {
        try await send(request: .send(url: .startSession(gameID: gameID), data: "", method: .post, token: getToken()), status: 201)
    }
    
    func endSession(id: UUID) async throws {
        try await send(request: .send(url: .endSession(id: id), data: "", method: .patch, token: getToken()), status: 200)
    }
    
    
    //GAMESESSION
}
