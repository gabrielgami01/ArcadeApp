import SwiftUI

struct TestInteractor: DataInteractor {
    func createUser(user: CreateUserDTO) async throws {
        
    }
    
    func loginJWT(user: String, pass: String) async throws {
        
    }
    
    func getConsolesGenres() async throws -> (consoles: [Console], genres: [Genre]) {
        let consoles = [Console(id: UUID(), name: "Arcade"),
                        Console(id: UUID(), name: "NES"),
                        Console(id: UUID(), name: "SNES"),
                        Console(id: UUID(), name: "SegaGenesis"),
                        Console(id: UUID(), name: "PlayStation"),
                        Console(id: UUID(), name: "N64"),
                        Console(id: UUID(), name: "Atari2600"),
                        Console(id: UUID(), name: "Gameboy"),
                        Console(id: UUID(), name: "Dreamcast"),
                        Console(id: UUID(), name: "Gamecube")
        ]
        let genres = [Genre(id: UUID(), name: "Action"),
                      Genre(id: UUID(), name: "Arcade"),
                      Genre(id: UUID(), name: "Adventure"),
                      Genre(id: UUID(), name: "RPG"),
                      Genre(id: UUID(), name: "Puzzle"),
                      Genre(id: UUID(), name: "Sports"),
                      Genre(id: UUID(), name: "Platformer"),
                      Genre(id: UUID(), name: "Shooter"),
                      Genre(id: UUID(), name: "Fighting"),
                      Genre(id: UUID(), name: "Racing"),
                      Genre(id: UUID(), name: "Simulation"),
                      Genre(id: UUID(), name: "Strategy")
        ]
        
        return (consoles, genres)
    }
    
    func loadData(file: String) throws -> [Game] {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else { return [] }
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([GameDTO].self, from: data).map(\.toGame)
    }
    
    func getGamesByMaster(master: Master) async throws -> [Game] {
        return if master is Console {
            try loadData(file: "games").filter { $0.console == master.name}
        } else {
            try loadData(file: "games").filter { $0.genre == master.name}
        }
    }
    
    func searchGame(name: String) async throws -> [Game] {
        try loadData(file: "games").filter { $0.name.contains(name)}
    }
    
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game]) {
        let featured = try loadData(file: "games").filter { $0.featured}
        let favorites = try loadData(file: "games").prefix(8).shuffled()
        
        return (featured, favorites)
    }
}


extension Console {
    static let test = Console(id: UUID(uuidString: "f076a3e7-40e2-42eb-be21-49c88761fdf4")!, name: "SNES")
}

extension Genre {
    static let test = Genre(id: UUID(uuidString: "241aad9e-df3a-4e90-9ef4-06d1e11725d0")!, name: "Action")
}

extension Game {
    static let test = Game(id: UUID(uuidString: "3d45be8a-9799-41e7-a415-1af44774be85")!,
                           name: "Pokémon Red and Blue",
                           description: "An rpg game where players capture and train Pokémon to become the Pokémon Champion.",
                           releaseDate: Calendar.current.date(from: DateComponents(year: 1996, month: 2, day: 27))!,
                           genre: "RPG",
                           console: "Gameboy",
                           imageURL: URL(string: ""),
                           videoURL: URL(string: ""),
                           featured: true)
}
