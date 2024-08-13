import Foundation
import SwiftUI

struct ChallengePageDTO: Codable {
    let items: [ChallengeDTO]
    let metadata: Metadata
}

struct ChallengeDTO: Codable {
    let id: UUID
    let name: String
    let description: String
    let targetScore: Int
    let type: ChallengeType
    let game: String
    
    func toChallenge(completed: Bool) -> Challenge {
        Challenge(id: id,
                  name: name,
                  description: description,
                  targetScore: targetScore,
                  type: type,
                  game: game,
                  completed: completed)
    }
}

struct Challenge: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let targetScore: Int
    let type: ChallengeType
    let game: String
    let completed: Bool
    
    func colorForChallenge() -> Color {
        switch self.type {
            case .all:
                return .white
            case .bronze:
                return .orange
            case .gold:
                return .yellow
            case .silver:
                return .gray
            
        }
    }
}
