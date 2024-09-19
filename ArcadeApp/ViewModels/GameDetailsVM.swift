import Foundation

@Observable
final class GameDetailsVM {
    let interactor: DataInteractor
    
    var isFavorite = false
    
    var reviews: [Review] = []
    @ObservationIgnored var globalRating: Double {
        guard !reviews.isEmpty else { return 0.0 }
           
        let totalRating = reviews.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(reviews.count)
    }
    
    var scores: [Score] = []
    @ObservationIgnored var verifiedScores: [Score] {
        scores.filter { $0.status == .verified }
    }
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    func getGameDetails(id: UUID) async {
        do {
            (isFavorite, reviews, scores) = try await interactor.getGameDetails(id: id)
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
        }
    }
    
    func toggleFavorite(gameID: UUID) async -> Bool {
        do {
            if isFavorite {
                try await interactor.deleteFavoriteGame(id: gameID)
            } else {
                let favoriteDTO = FavoriteDTO(gameID: gameID)
                try await interactor.addFavoriteGame(favoriteDTO)
            }
            return true
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
            return false
        }
    }
    
    func addReviewAPI(_ review: Review, to game: Game) async -> Bool {
        do {
            let reviewDTO = CreateReviewDTO(title: review.title, comment: review.comment, rating: review.rating, gameID: game.id)
            try await interactor.addReview(reviewDTO)
            return true
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
            return false
        }
    }
    
    func addReview(_ review: Review) {
        reviews.append(review)
    }
    
    func addScoreAPI(imageData: Data, to game: Game) async -> Bool {
        do {
            let scoreDTO = CreateScoreDTO(image: imageData, gameID: game.id)
            try await interactor.addScore(scoreDTO)
            return true
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
            return false
        }
    }
    
    func addScore(_ score: Score) {
        scores.append(score)
    }
}
