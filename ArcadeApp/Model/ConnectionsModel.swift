import Foundation

struct UserConnections: Codable, Identifiable, Hashable {
    let id: UUID
    let user: User
    let createdAt: Date
}

struct ConnectionsDTO: Codable {
    let userID: UUID
}
