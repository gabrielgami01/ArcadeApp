import Foundation

struct Score: Codable, Identifiable, Hashable {
    let id: UUID
    let score: Int?
    let state: ScoreState
    let date: Date
}

struct CreateScoreDTO: Codable {
    let image: Data
    let gameID: UUID
}
