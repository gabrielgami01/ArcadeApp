import Foundation

struct ReviewDTO: Codable {
    let id: UUID
    let title: String
    let comment: String?
    let rating: Int
    let date: Date
    let username: String
    let avatarURL: String?
    
    var toReview: Review {
        Review(id: id,
               title: title,
               comment: comment,
               rating: rating,
               date: date,
               username: username,
               avatarURL: URL(string: avatarURL ?? ""))
    }
}

struct Review: Identifiable, Hashable {
    let id: UUID
    let title: String
    let comment: String?
    let rating: Int
    let date: Date
    let username: String
    let avatarURL: URL?
}

struct CreateReviewDTO: Codable {
    let title: String
    let comment: String?
    let rating: Int
    let gameID: UUID
}
