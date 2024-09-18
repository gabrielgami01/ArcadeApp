import Foundation

struct Score: Codable, Identifiable, Hashable {
    let id: UUID
    let score: Int?
    let status: ScoreStatus
    let date: Date
}

struct CreateScoreDTO: Codable {
    let image: Data
    let gameID: UUID
}

struct RankingScorePageDTO: Codable {
    let items: [RankingScore]
    let metadata: Metadata
}

struct RankingScore: Codable, Identifiable, Hashable {
    let id: UUID
    let score: Int
    let date: Date
    let user: User
}
