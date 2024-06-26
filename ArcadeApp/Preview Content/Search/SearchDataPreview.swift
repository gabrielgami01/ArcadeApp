import SwiftUI

struct SearchInteractorTest: SearchInteractorProtocol {
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
    
    func getGamesByConsole(id: UUID) async throws -> [Game] {
        []
    }
    
    func getGamesByGenre(id: UUID) async throws -> [Game] {
        []
    }
}


extension Console {
    static let test = Console(id: UUID(uuidString: "ca7b48a7-a212-4673-80cb-a884e43387e9")!, name: "SNES")
}

extension Genre {
    static let test = Genre(id: UUID(uuidString: "4638734c-fc58-4e3d-941a-a8885cf7b05d")!, name: "Action")
}
