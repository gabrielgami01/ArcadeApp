import Foundation

protocol GenreConsole {
    var id: UUID { get }
    var name: String { get }
}

struct Genre: Codable, Identifiable, Hashable, GenreConsole {
    let id: UUID
    let name: String
}

struct Console: Codable, Identifiable, Hashable, GenreConsole {
    let id: UUID
    let name: String
}

struct GameDTO: Codable {
    let id: UUID
    let name: String
    let description: String
    let releaseDate: Date
    let genre: String
    let console: String
    let imageURL: String?
    let videoURL: String?
    let featured: Bool
    
    var toGame: Game {
        Game(
            id: id,
            name: name,
            description: description,
            releaseDate: releaseDate,
            genre: genre,
            console: console,
            imageURL: URL(string: imageURL ?? ""),
            videoURL: URL(string: videoURL ?? ""),
            featured: featured)
    }
}

struct Game: Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let releaseDate: Date
    let genre: String
    let console: String
    let imageURL: URL?
    let videoURL: URL?
    let featured: Bool
}
