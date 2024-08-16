import Foundation
import ACNetwork

protocol DataInteractor {
    func createUser(user: CreateUserDTO) async throws
    func loginJWT(user: String, pass: String) async throws -> User
    func refreshJWT() async throws -> User
    func getUserInfo() async throws -> User
    func editUserAbout(about: EditUserAboutDTO) async throws
    
    func getAllGames(page: Int) async throws -> [Game]
    func getGamesByConsole(name: String, page: Int) async throws -> [Game]
    func searchGame(name: String, page: Int) async throws -> [Game]
    
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game]) 
    
    func getGameDetails(id: UUID) async throws -> (favorite: Bool, reviews: [Review], scores: [Score])
    func addFavoriteGame(id: UUID) async throws
    func removeFavoriteGame(id: UUID) async throws
    func addReview(review: CreateReviewDTO) async throws
    func addScore(score: CreateScoreDTO) async throws
    
    func getAllChallenges(page: Int) async throws -> [Challenge]
    func getChallengesByType(type: String, page: Int) async throws -> [Challenge]
    
    func getGameRanking(id: UUID, page: Int) async throws -> [RankingScore]
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
    
    func editUserAbout(about: EditUserAboutDTO) async throws {
        try await post(request: .post(url: .editUserAbout, post: about, method: .put, token: getToken()))
    }
    //END USERS
    
    //SEARCH
    func getAllGames(page: Int) async throws -> [Game] {
        try await getJSON(request: .get(url: .getAllGames(page: page), token: getToken()), type: GamePageDTO.self).items
    }
    
    func getGamesByConsole(name: String, page: Int) async throws -> [Game] {
        try await getJSON(request: .get(url: .getGamesByConsole(name: name, page: page), token: getToken()), type: GamePageDTO.self).items
    }
    
    func searchGame(name: String, page: Int) async throws -> [Game] {
        try await getJSON(request: .get(url: .searchGame(name: name, page: page), token: getToken()), type: GamePageDTO.self).items
    }

    //END SEARCH
    
    //HOME
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game]) {
        async let featuredRequest = getJSON(request: .get(url: .getFeaturedGames, token: getToken()), type: [GameDTO].self).map(\.toGame)
        async let favoritesRequest = getJSON(request: .get(url: .favoriteGames, token: getToken()), type: [GameDTO].self).map(\.toGame)
        
        return try await (featuredRequest, favoritesRequest)
    }
    //HOME
    
    //DETAILS
    func getGameDetails(id: UUID) async throws -> (favorite: Bool, reviews: [Review], scores: [Score]) {
        async let favoriteRequest = getJSON(request: .get(url: .isFavoriteGame(id: id), token: getToken()), type: Bool.self)
        async let reviewsRequest = getJSON(request: .get(url: .getGameReviews(id: id),token: getToken()), type: [ReviewDTO].self).map(\.toReview)
        async let scoresRequest  = getJSON(request: .get(url: .getGameScores(id: id),token: getToken()), type: [Score].self)
        
        return try await (favoriteRequest, reviewsRequest, scoresRequest)
    }
    
    func addFavoriteGame(id: UUID) async throws {
        let favoriteGameDTO = FavoriteGameDTO(id: id)
        try await post(request: .post(url: .favoriteGames, post: favoriteGameDTO, token: getToken()), status: 201)
    }
    
    func removeFavoriteGame(id: UUID) async throws {
        let favoriteGameDTO = FavoriteGameDTO(id: id)
        try await post(request: .post(url: .favoriteGames, post: favoriteGameDTO, method: .delete, token: getToken()))
    }

    func addReview(review: CreateReviewDTO) async throws {
        try await post(request: .post(url: .reviews, post: review, token: getToken()), status: 201)
    }
    
   
    func addScore(score: CreateScoreDTO) async throws {
        try await post(request: .post(url: .scores, post: score, token: getToken()), status: 201)
    }
    
    //DETAILS
    
    //CHALLENGES
    func getAllChallenges(page: Int) async throws -> [Challenge] {
        let challengesDTO = try await getJSON(request: .get(url: .getAllChallenges(page: page), token: getToken()),type: ChallengePageDTO.self).items
        
        var challenges: [Challenge] = []
        challenges.reserveCapacity(challengesDTO.count)
        
        for challengeDTO in challengesDTO {
            async let completed = getJSON(request: .get(url: .isChallengeCompleted(id: challengeDTO.id), token: getToken()),type: Bool.self)
            
            let challenge = challengeDTO.toChallenge(completed: try await completed)
            challenges.append(challenge)
        }
        
        return challenges
    }
    
    func getChallengesByType(type: String, page: Int) async throws -> [Challenge] {
        let challengesDTO = try await getJSON(request: .get(url: .getChallengesByType(type: type, page: page), token: getToken()),type: ChallengePageDTO.self).items
        
        var challenges: [Challenge] = []
        challenges.reserveCapacity(challengesDTO.count)
        
        for challengeDTO in challengesDTO {
            async let completed = getJSON(request: .get(url: .isChallengeCompleted(id: challengeDTO.id), token: getToken()),type: Bool.self)
            
            let challenge = challengeDTO.toChallenge(completed: try await completed)
            challenges.append(challenge)
        }
        
        return challenges
    }
    //CHALLENGES
    
    //RANKINGS
    func getGameRanking(id: UUID, page: Int) async throws -> [RankingScore] {
        try await getJSON(request: .get(url: .getGameRanking(id: id, page: page), token: getToken()), type: RankingScorePageDTO.self).items
    }
    //RANKINGS
    
}
