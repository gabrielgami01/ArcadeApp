import Foundation

struct Emblem: Codable, Identifiable, Hashable {
    let id: UUID
    let challenge: Challenge
}

struct EmblemDTO: Codable {
    let challengeID: UUID
}
