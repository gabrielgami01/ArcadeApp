import Foundation

struct Review: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let comment: String?
    let rating: Int
    let date: Date
    let username: String
    let avatarImage: Data?
}

struct CreateReviewDTO: Codable {
    let title: String
    let comment: String?
    let rating: Int
    let gameID: UUID
}
