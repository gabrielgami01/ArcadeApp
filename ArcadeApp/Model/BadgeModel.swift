import Foundation

struct Badge: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let featured: Bool
    let order: Int?
    let challengeType: ChallengeType
    let game: String
    let completedAt: Date
}

struct HighlightBadgeDTO: Codable {
    let id: UUID
    let order: Int
}
