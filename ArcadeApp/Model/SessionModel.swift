import Foundation

struct GameSession: Codable, Identifiable, Hashable {
    let id: UUID
    let status: SessionStatus
    let start: Date
    let end: Date?
    let game: Game
}

struct GameSessionDTO: Codable {
    let id: UUID
    let gameID: UUID
}
