import SwiftUI

@Observable
final class AddReviewVM {
    
    var title = ""
    var rating = 0
    var comment = ""

    var errorMsg = ""
    var showError = false
    
    func newReview(activeUser: User) -> Review? {
        return if checkReview() {
            Review(id: UUID(),
                   title: title,
                   comment: comment, rating: rating,
                   date: .now,
                   user: activeUser)
        } else {
            nil
        }
    }
    
    func checkReview() -> Bool {
        errorMsg = ""
        
        if title.isEmpty {
            errorMsg = "The review must have a title."
        }
        if rating == 0 {
            errorMsg += "The review must have a min rating of 1."
        }
        
        return errorMsg.isEmpty
    }
}
