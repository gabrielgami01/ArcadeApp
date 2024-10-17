import Foundation
import SwiftData

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

struct GameDTO: Codable {
    let gameID: UUID
}

@Model
final class GameModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var desc: String
    var console: String
    var genre: String
    var releaseDate: Date
    var added: Date

    init(id: UUID, name: String, desc: String, console: String, genre: String, releaseDate: Date, added: Date) {
        self.id = id
        self.name = name
        self.desc = desc
        self.console = console
        self.genre = genre
        self.releaseDate = releaseDate
        self.added = added
    }
    
    var toGame: Game {
        Game(id: id,
             name: name,
             description: desc,
             console: Console(rawValue: console) ?? .nes,
             genre: Genre(rawValue: genre) ?? .action,
             releaseDate: releaseDate,
             featured: false)
    }
}
