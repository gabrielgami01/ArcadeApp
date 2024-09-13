import Foundation

struct UserFollows: Codable, Identifiable, Hashable {
    let id: UUID
    let user: User
    let createdAt: Date
}

struct FollowsDTO: Codable {
    let userID: UUID
}
