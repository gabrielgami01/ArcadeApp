import Foundation

struct Session: Codable, Identifiable, Hashable {
    let id: UUID
    let status: SessionStatus
    let start: Date
    let end: Date?
    let userID: UUID
    let game: Game    
}

struct SessionDTO: Codable {
    let id: UUID
    let gameID: UUID
}
