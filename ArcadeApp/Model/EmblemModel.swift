import Foundation

struct Emblem: Codable, Identifiable, Hashable {
    let id: UUID
    let challenge: Challenge
}

struct CreateEmblemDTO: Codable {
    let challengeID: UUID
}
