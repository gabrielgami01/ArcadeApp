import Foundation

struct GameDTO: Codable {
    let id: UUID
    let name: String
    let description: String
    let console: Console
    let genre: Genre
    let releaseDate: Date
    let imageURL: String?
    let featured: Bool
    
    var toGame: Game {
        Game(
            id: id,
            name: name,
            description: description,
            console: console,
            genre: genre,
            releaseDate: releaseDate,
            imageURL: URL(string: imageURL ?? ""),
            featured: featured)
    }
}

struct GamePageDTO: Codable {
    let items: [GameItem]
    let metadata: Metadata
}

struct GameItem: Codable {
    let id: UUID
    let name: String
    let description: String
    let console: Console
    let genre: Genre
    let releaseDate: Date
    let imageURL: String?
    let featured: Bool
    
    var toGame: Game {
        Game(
            id: id,
            name: name,
            description: description,
            console: console,
            genre: genre,
            releaseDate: releaseDate,
            imageURL: URL(string: imageURL ?? ""),
            featured: featured)
    }
}

struct Metadata: Codable {
    let page, per, total: Int
}


struct Game: Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let console: Console
    let genre: Genre
    let releaseDate: Date
    let imageURL: URL?
    let featured: Bool
}

struct FavoriteGameDTO: Codable {
    let id: UUID
}
