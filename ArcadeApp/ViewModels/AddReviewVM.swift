import SwiftUI

@Observable
final class AddReviewVM {
    let interactor: DataInteractor
    
    let game: Game
    
    var title = ""
    var rating = 0
    var comment = ""

    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared, game: Game) {
        self.interactor = interactor
        self.game = game
    }
    
    func addReview() {
        Task {
            do {
                let review = CreateReviewDTO(title: title, comment: comment, rating: rating, gameID: game.id)
                try await interactor.addReview(review: review)
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func checkReview() -> Bool {
        self.errorMsg = ""
        if title.isEmpty {
            self.errorMsg = "The review must have a title."
        }
        if rating == 0 {
            self.errorMsg += "The review must have a min rating of 1."
        }
        
        return errorMsg.isEmpty
    }
}
