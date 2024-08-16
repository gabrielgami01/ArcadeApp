import SwiftUI

struct TestInteractor: DataInteractor {
    func createUser(user: CreateUserDTO) async throws {
        
    }
    
    func loginJWT(user: String, pass: String) async throws  -> User {
        .test
    }
    
    func refreshJWT() async throws -> User {
        .test
    }
    
    func getUserInfo() async throws -> User {
        .test
    }
    
    func editUserAbout(about: EditUserAboutDTO) async throws {
        
    }
    
    func loadData(file: String) throws -> [Game] {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else { return [] }
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([GameDTO].self, from: data).map(\.toGame)
    }
    
    func getAllGames(page: Int) async throws -> [Game] {
        try loadData(file: "games")
    }
    
    func getGamesByConsole(name: String, page: Int) async throws -> [Game] {
        try loadData(file: "games").filter { $0.console.rawValue == name }
    }
    
    func searchGame(name: String, page: Int) async throws -> [Game] {
        try loadData(file: "games").filter { $0.name.contains(name)}
    }
    
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game]) {
        let featured = try loadData(file: "games").filter { $0.featured}
        let favorites = Array(try loadData(file: "games").prefix(8).shuffled())
        
        return (featured, favorites)
    }
    
    func getGameDetails(id: UUID) async throws -> (favorite: Bool, reviews: [Review], scores: [Score]) {
        return (true, [Review.test,Review.test2,Review.test3], [Score.test, Score.test2, Score.test3, Score.test4, Score.test5])
    }
    
    
    func addFavoriteGame(id: UUID) async throws {
        
    }
    
    func removeFavoriteGame(id: UUID) async throws {
        
    }
    
    func addReview(review: CreateReviewDTO) async throws {
        
    }

    func addScore(score: CreateScoreDTO) async throws {
        
    }
    
    func getAllChallenges(page: Int) async throws -> [Challenge] {
        return [.test, .test2, .test3, .test4, .test5].sorted { $0.game < $1.game}
    }
    
    func getChallengesByType(type: String, page: Int) async throws -> [Challenge] {
        let challenges: [Challenge] = [.test, .test2, .test3, .test4, .test5]
        return challenges.filter{ $0.type.rawValue == type }
    }
    
    func getGameRanking(id: UUID, page: Int) async throws -> [RankingScore] {
        let scores: [RankingScore] = [.test, .test2, .test3, .test4]
        return scores.sorted { $0.score > $1.score}
    }
}

extension User {
    static let test = User(id: UUID(), email: "gabrielgmcv01@gmail.com", username: "gabrielgm", fullName: "gabriel", biography: "De locos")
}

extension Game {
    static let test = Game(id: UUID(),
                           name: "Pokémon Red and Blue",
                           description: "An rpg game where players capture and train Pokémon to become the Pokémon Champion.",
                           console: .gameboy,
                           genre: .rpg,
                           releaseDate: Calendar.current.date(from: DateComponents(year: 1996, month: 2, day: 27))!,
                           featured: true)
    static let test2 = Game(id: UUID(),
                           name: "Super Mario Bros.",
                           description: "A platform game where players control Mario and Luigi to save Princess Toadstool.",
                           console: .nes,
                           genre: .platformer,
                           releaseDate: Calendar.current.date(from: DateComponents(year: 1985, month: 9, day: 13))!,
                           featured: false)
}

extension Review {
    static let test = Review(id: UUID(), 
                             title: "Juego increíble",
                             comment: "Me ha encantado el juego es adictivo",
                             rating: 3,
                             date: .now,
                             username: "gabrielgm",
                             avatarURL: nil)
    static let test2 = Review(id: UUID(),
                             title: "Muy aburrido",
                             comment: nil,
                             rating: 1,
                             date: .now,
                             username: "gabrielgm",
                             avatarURL: nil)
    static let test3 = Review(id: UUID(),
                             title: "WOW",
                             comment: "El mejor juego de la historia",
                             rating: 5,
                             date: .now,
                             username: "gabrielgm",
                             avatarURL: nil)
}

extension Score {
    static let test = Score(id: UUID(),
                            score: nil,
                            state: .unverified,
                            date: .now)
    static let test2 = Score(id: UUID(),
                            score: 5500,
                            state: .verified,
                            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 1, hour: 22, minute: 30)) ?? .now)
    static let test3 = Score(id: UUID(),
                            score: 6000,
                            state: .verified,
                            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5, hour: 15, minute: 22)) ?? .now)
    static let test4 = Score(id: UUID(),
                            score: 4440,
                            state: .verified,
                            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 10, hour: 16, minute: 33)) ?? .now)
    static let test5 = Score(id: UUID(),
                            score: 5323,
                            state: .verified,
                            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 22, hour: 14, minute: 02)) ?? .now)
}

extension Challenge {
    static let test = Challenge(id: UUID(),
                                name: "Mushroom Champion",
                                description: "Score 100,000 points by collecting coins and defeating enemies.",
                                targetScore: 100000,
                                type: .gold,
                                game: "Super Mario Bros",
                                completed: true)
    
    static let test2 = Challenge(id: UUID(),
                                 name: "Hero of Hyrule",
                                 description: "Reach a score of 50,000 points by defeating bosses and collecting items.",
                                 targetScore: 50000,
                                 type: .bronze,
                                 game: "The Legend of Zelda",
                                 completed: true)
    static let test3 = Challenge(id: UUID(),
                                 name: "Speed Demon",
                                 description: "Achieve a score of 75,000 points by collecting rings and defeating Dr. Robotnik.",
                                 targetScore: 75000,     
                                 type: .gold,
                                 game: "Sonic the Hedgehog",
                                 completed: false)
    
    static let test4 = Challenge(id: UUID(),
                                 name: "Martial Arts Master",
                                 description: "Score 80,000 points by winning matches in Street Fighter II.",
                                 targetScore: 80000,
                                 type: .bronze,
                                 game: "Street Fighter II",
                                 completed: true)
    static let test5 = Challenge(id: UUID(),
                                 name: "Mako Reactor Hero",
                                 description: "Reach a score of 60,000 points by completing quests and defeating enemies.",
                                 targetScore: 60000,
                                 type: .silver,
                                 game: "Final Fantasy VII",
                                 completed: false)
    
}

extension RankingScore {
    static let test = RankingScore(id: UUID(),
                                   score: 5500,
                                   date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 1, hour: 22, minute: 30)) ?? .now,
                                   user: User.test.username)
    static let test2 = RankingScore(id: UUID(),
                                   score: 6000,
                                   date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5, hour: 15, minute: 22)) ?? .now,
                                   user: User.test.username)
    static let test3 = RankingScore(id: UUID(),
                                   score: 4440,
                                   date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 10, hour: 16, minute: 33)) ?? .now,
                                   user: User.test.username)
    static let test4 = RankingScore(id: UUID(),
                                   score: 5323,
                                   date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 22, hour: 14, minute: 02)) ?? .now,
                                   user: User.test.username)
}
