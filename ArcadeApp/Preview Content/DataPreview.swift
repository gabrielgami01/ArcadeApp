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
    
    func isFavoriteGame(id: UUID) async throws -> Bool {
        return true
    }
    
    func addFavoriteGame(id: UUID) async throws {
        
    }
    
    func removeFavoriteGame(id: UUID) async throws {
        
    }
    
    func getGameReviews(id: UUID) async throws -> [Review] {
        [.test, .test2, .test3]
    }
    
    func addReview(review: CreateReviewDTO) async throws {
        
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
