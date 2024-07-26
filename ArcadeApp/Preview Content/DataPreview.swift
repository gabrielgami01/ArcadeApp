import SwiftUI

struct TestInteractor: DataInteractor {
    
    func createUser(user: CreateUserDTO) async throws {
        
    }
    
    func loginJWT(user: String, pass: String) async throws {
        
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
        let favorites = try loadData(file: "games").prefix(8).shuffled()
        
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
}

extension Game {
    static let test = Game(id: UUID(),
                           name: "Pokémon Red and Blue",
                           description: "An rpg game where players capture and train Pokémon to become the Pokémon Champion.",
                           console: .gameboy,
                           genre: .rpg,
                           releaseDate: Calendar.current.date(from: DateComponents(year: 1996, month: 2, day: 27))!,
                           imageURL: URL(string: "google.com"),
                           featured: true)
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
