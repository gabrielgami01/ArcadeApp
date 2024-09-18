import Foundation
import ACNetwork

protocol DataInteractor {
    func register(user: CreateUserDTO) async throws
    func loginJWT(user: String, pass: String) async throws -> User
    func refreshJWT() async throws -> User
    func getUserInfo() async throws -> User
    func updateUserAbout(_ updateUserDTO: UpdateUserDTO) async throws
    func updateUserAvatar(_ updateUserDTO: UpdateUserDTO) async throws
    
    func getAllGames(page: Int) async throws -> [Game]
    func getGamesByConsole(_ console: Console, page: Int) async throws -> [Game]
    func searchGame(name: String) async throws -> [Game]
    
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game]) 
    
    func getGameDetails(id: UUID) async throws -> (favorite: Bool, reviews: [Review], scores: [Score])
    func addFavoriteGame(_ game: FavoriteDTO) async throws
    func deleteFavoriteGame(id: UUID) async throws
    func addReview(_ review: CreateReviewDTO) async throws
    func addScore(_ score: CreateScoreDTO) async throws
    
    func getAllChallenges() async throws -> [Challenge]
    func getChallengesByType(_ type: ChallengeType) async throws -> [Challenge]
    func getCompletedChallenges() async throws -> [Challenge]
    
    func getActiveUserEmblems() async throws -> [Emblem]
    func getUserEmblems(id: UUID) async throws -> [Emblem]
    func addEmblem(_ emblemDTO: CreateEmblemDTO) async throws
    func deleteEmblem(challengeID: UUID) async throws
    
    func getGameRanking(id: UUID, page: Int) async throws -> [RankingScore]
    
    func getFollowingFollowers() async throws -> (following: [UserConnections], followers: [UserConnections])
    func followUser(_ connectionsDTO: ConnectionsDTO) async throws
    func unfollowUser(id: UUID) async throws
}

struct Network: DataInteractor, NetworkJSONInteractor {
    let session: URLSession
    
    static let shared = Network()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getToken() -> String? {
        guard let token = SecKeyStore.shared.readKey(label: "token") else {
            return nil
        }
        return String(data: token, encoding: .utf8)
    }
    
    //USERS
    func register(user: CreateUserDTO) async throws {
        var request: URLRequest = .post(url: .createUser, post: user)
        request.setValue(SecManager.shared.appAPIKEY, forHTTPHeaderField: "App-APIKey")
        
        try await post(request: request, status: 201)
    }
    
    func loginJWT(user: String, pass: String) async throws -> User {
        let token = "\(user):\(pass)".data(using: .utf8)?.base64EncodedString()
        let loginDTO = try await getJSON(request: .get(url: .loginJWT, token: token, authType: .basic), type: LoginDTO.self)
        SecKeyStore.shared.storeKey(key: Data(loginDTO.token.utf8), label: "token")
        NotificationCenter.default.post(name: .login, object: nil)
        
        return loginDTO.user
    }
    
    func refreshJWT() async throws -> User {
        let loginDTO = try await getJSON(request: .get(url: .refreshJWT, token: getToken()), type: LoginDTO.self)
        SecKeyStore.shared.deleteKey(label: "token")
        SecKeyStore.shared.storeKey(key: Data(loginDTO.token.utf8), label: "token")
       
        return loginDTO.user
    }
    
    func getUserInfo() async throws -> User {
        try await getJSON(request: .get(url: .getUserInfo, token: getToken()), type: User.self)
    }
    
    func updateUserAbout(_ updateUserDTO: UpdateUserDTO) async throws {
        try await post(request: .post(url: .updateUserAbout, post: updateUserDTO, method: .put, token: getToken()))
    }
    
    func updateUserAvatar(_ updateUserDTO: UpdateUserDTO) async throws {
        try await post(request: .post(url: .updateUserAvatar, post: updateUserDTO, method: .put, token: getToken()))
    }
    //END USERS
    
    //SEARCH
    func getAllGames(page: Int) async throws -> [Game] {
        try await getJSON(request: .get(url: .getAllGames(page: page), token: getToken()), type: GamePageDTO.self).items
    }
    
    func getGamesByConsole(_ console: Console, page: Int) async throws -> [Game] {
        try await getJSON(request: .get(url: .getGamesByConsole(name: console.rawValue, page: page), token: getToken()), type: GamePageDTO.self).items
    }
    
    func searchGame(name: String) async throws -> [Game] {
        try await getJSON(request: .get(url: .searchGame(name: name), token: getToken()), type: [Game].self)
    }

    //END SEARCH
    
    //HOME
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game]) {
        async let featuredRequest = getJSON(request: .get(url: .getFeaturedGames, token: getToken()), type: [Game].self)
        async let favoritesRequest = getJSON(request: .get(url: .getUserFavoriteGames, token: getToken()), type: [Game].self)
        
        return try await (featuredRequest, favoritesRequest)
    }
    //HOME
    
    //DETAILS
    func getGameDetails(id: UUID) async throws -> (favorite: Bool, reviews: [Review], scores: [Score]) {
        async let favoriteRequest = getJSON(request: .get(url: .isFavoriteGame(id: id), token: getToken()), type: Bool.self)
        async let reviewsRequest = getJSON(request: .get(url: .getGameReviews(id: id),token: getToken()), type: [Review].self)
        async let scoresRequest  = getJSON(request: .get(url: .getGameScores(id: id),token: getToken()), type: [Score].self)
        
        return try await (favoriteRequest, reviewsRequest, scoresRequest)
    }
    
    func addFavoriteGame(_ game: FavoriteDTO) async throws{
        try await post(request: .post(url: .addFavoriteGame, post: game, token: getToken()), status: 201)
    }
    
    func deleteFavoriteGame(id: UUID) async throws {
        try await post(request: .post(url: .deleteFavoriteGame(id: id), post: "", method: .delete, token: getToken()))
    }

    func addReview(_ review: CreateReviewDTO) async throws {
        try await post(request: .post(url: .addReview, post: review, token: getToken()), status: 201)
    }
    
   
    func addScore(_ score: CreateScoreDTO) async throws {
        try await post(request: .post(url: .addScore, post: score, token: getToken()), status: 201)
    }
    
    //DETAILS
    
    //CHALLENGES
    func getAllChallenges() async throws -> [Challenge] {
        let challengesDTO = try await getJSON(request: .get(url: .getAllChallenges, token: getToken()), type: [ChallengeDTO].self)
        
        var challenges: [Challenge] = []
        challenges.reserveCapacity(challengesDTO.count)
        
        for challengeDTO in challengesDTO {
            async let completed = getJSON(request: .get(url: .isChallengeCompleted(id: challengeDTO.id), token: getToken()),type: Bool.self)
            
            let challenge = challengeDTO.toChallenge(completed: try await completed)
            challenges.append(challenge)
        }
        
        return challenges
    }
    
    func getChallengesByType(_ type: ChallengeType) async throws -> [Challenge] {
        let challengesDTO = try await getJSON(request: .get(url: .getChallengesByType(type: type.rawValue), token: getToken()),type: [ChallengeDTO].self)
        
        var challenges: [Challenge] = []
        challenges.reserveCapacity(challengesDTO.count)
        
        for challengeDTO in challengesDTO {
            async let completed = getJSON(request: .get(url: .isChallengeCompleted(id: challengeDTO.id), token: getToken()),type: Bool.self)
            
            let challenge = challengeDTO.toChallenge(completed: try await completed)
            challenges.append(challenge)
        }
        
        return challenges
    }
    
    func getCompletedChallenges() async throws -> [Challenge] {
        let challengesDTO = try await getJSON(request: .get(url: .getCompletedChallenges, token: getToken()), type: [ChallengeDTO].self)
        let challenges = challengesDTO.map {$0.toChallenge(completed: true)}
        
        return challenges
    }
    //CHALLENGES
    
    //EMBLEMS
    func getActiveUserEmblems() async throws -> [Emblem] {
        try await getJSON(request: .get(url: .getActiveUserEmblems, token: getToken()), type: [EmblemDTO].self).map(\.toEmblem)
    }
    
    func getUserEmblems(id: UUID) async throws -> [Emblem] {
        try await getJSON(request: .get(url: .getUserEmblems(id: id), token: getToken()), type: [EmblemDTO].self).map(\.toEmblem)
    }
    
    func addEmblem(_ emblemDTO: CreateEmblemDTO ) async throws {
        try await post(request: .post(url: .addEmblem, post: emblemDTO, token: getToken()), status: 201)
    }
    
    func deleteEmblem(challengeID: UUID) async throws {
        try await post(request: .post(url: .deleteEmblem(challengeID: challengeID), post: "", method: .delete, token: getToken()))
    }
    //EMBLEMS
    
    //RANKINGS
    func getGameRanking(id: UUID, page: Int) async throws -> [RankingScore] {
        try await getJSON(request: .get(url: .getGameRanking(id: id, page: page), token: getToken()), type: RankingScorePageDTO.self).items
    }
    //RANKINGS
    
    //FOLLOW
    func getFollowingFollowers() async throws -> (following: [UserConnections], followers: [UserConnections]) {
        async let followingRequest = getJSON(request: .get(url: .listFollowing, token: getToken()), type: [UserConnections].self)
        async let followersRequest = getJSON(request: .get(url: .listFollowers, token: getToken()), type: [UserConnections].self)
        
        return try await(followingRequest, followersRequest)
    }
    
    func followUser(_ connectionsDTO: ConnectionsDTO) async throws {
        try await post(request: .post(url: .followUser, post: connectionsDTO, token: getToken()), status: 201)
    }
    
    func unfollowUser(id: UUID) async throws {
        try await post(request: .post(url: .unfollowUser(id: id), post: "", method: .delete, token: getToken()))
    }
    
    //FOLLOW
    
}
