import Foundation

struct Emblem: Codable, Identifiable, Hashable {
    let id: UUID
    let challenge: Challenge
}

struct EmblemDTO: Codable {
    let id: UUID
    let challenge: ChallengeDTO
    
    var toEmblem: Emblem {
        Emblem(id: id,
               challenge: challenge.toChallenge(completed: true))
    }
}

struct CreateEmblemDTO: Codable {
    let challengeID: UUID
}
