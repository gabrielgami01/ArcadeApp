import Foundation
import SwiftData

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
            featured: featured)
    }
}

struct GamePageDTO: Codable {
    let items: [Game]
    let metadata: Metadata
}

struct Game: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let console: Console
    let genre: Genre
    let releaseDate: Date
    let featured: Bool
    
    var imageURL: URL {
        desa.appending(path: "covers").appending(path: "\(id).jpg")
    }
}

struct Metadata: Codable {
    let page, per, total: Int
}

struct FavoriteGameDTO: Codable {
    let id: UUID
}

@Model
final class GameModel {
    @Attribute (.unique) let id: UUID
    let name: String
    @Attribute(.externalStorage) let image: Data?
    let added: Date

    init(id: UUID, name: String, image: Data?, added: Date = .now) {
        self.id = id
        self.name = name
        self.image = image
        self.added = added
    }
}
