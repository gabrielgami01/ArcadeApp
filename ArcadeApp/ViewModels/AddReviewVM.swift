import SwiftUI

@Observable
final class AddReviewVM {
    let interactor: DataInteractor
    
    let game: Game
    
    var title = ""
    var rating = 0
    var comment = ""

    var errorMsg = ""
    var showError = false
    
    init(game: Game, interactor: DataInteractor = Network.shared) {
        self.game = game
        self.interactor = interactor
    }
    
    func addReview() {
        Task {
            do {
                let reviewDTO = CreateReviewDTO(title: title, comment: comment, rating: rating, gameID: game.id)
                try await interactor.addReview(reviewDTO)
                NotificationCenter.default.post(name: .details, object: nil, userInfo: ["gameID": game.id])
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
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
