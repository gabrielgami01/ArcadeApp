import SwiftUI

enum Console: String, Codable, Identifiable, CaseIterable {
    case all = "All"
    case atari2600 = "Atari2600"
    case gameboy = "Gameboy"
    case gamecube = "Gamecube"
    case dreamcast = "Dreamcast"
    case nes = "NES"
    case n64 = "N64"
    case playstation = "PlayStation"
    case snes = "SNES"
    case segagenesis = "SegaGenesis"

    var id: Self { self }
}

enum Genre: String, Codable {
    case action = "Action"
    case arcade = "Arcade"
    case adventure = "Adventure"
    case rpg = "RPG"
    case puzzle = "Puzzle"
    case sports = "Sports"
    case platformer = "Platformer"
    case shooter = "Shooter"
    case fighting = "Fighting"
    case racing = "Racing"
    case simulation = "Simulation"
    case strategy = "Strategy"
}

enum ScoreStatus: String, Codable {
    case verified
    case unverified
    case denied
}

enum ChallengeType: String, Codable {
    case all
    case gold
    case silver
    case bronze
    
    func colorForChallengeType() -> Color {
        switch self {
            case .all:
                return .white
            case .bronze:
                return .orange
            case .gold:
                return .yellow
            case .silver:
                return .gray
            
        }
    }
}

enum SessionStatus: String, Codable {
    case active
    case finished
}
