import Foundation
import SwiftUI

struct Challenge: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let targetScore: Int
    let type: ChallengeType
    let game: String
    let isCompleted: Bool
}
