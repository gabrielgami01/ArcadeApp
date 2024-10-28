import Foundation

@Observable
final class GameDetailsVM {
    let repository: RepositoryProtocol
    
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
    @ObservationIgnored var maxDisplayScore: Double {
        (verifiedScores.map { Double($0.score ?? 0) }.max() ?? 0) * 1.25
    }
    @ObservationIgnored var minDisplayDate: Date {
        (verifiedScores.map { $0.date }.min() ?? Date()).addingTimeInterval(-2 * 24 * 60 * 60)
    }
    @ObservationIgnored var maxDisplayDate: Date {
       (verifiedScores.map { $0.date }.max() ?? Date()).addingTimeInterval(2 * 24 * 60 * 60)
    }
    
    var sessions: [Session] = []
    
    var errorMsg = ""
    var showError = false
    
    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
    }
    
    func getGameDetails(id: UUID) async {
        do {
            let (isFavorite, reviews, scores, sessions) = try await repository.getGameDetails(id: id)
            await MainActor.run {
                self.isFavorite = isFavorite
                self.reviews = reviews
                self.scores = scores
                self.sessions = sessions
            }
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func toggleFavorite(gameID: UUID) async -> Bool {
        do {
            if isFavorite {
                try await repository.deleteFavoriteGame(id: gameID)
            } else {
                try await repository.addFavoriteGame(id: gameID)
            }
            return true
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
            return false
        }
    }
    
    func addReviewAPI(_ review: Review, to game: Game) async -> Bool {
        do {
            let reviewDTO = CreateReviewDTO(title: review.title, comment: review.comment, rating: review.rating, gameID: game.id)
            try await repository.addReview(reviewDTO)
            return true
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
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
            try await repository.addScore(scoreDTO)
            return true
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
            return false
        }
    }
    
    func addScore(_ score: Score) {
        scores.append(score)
    }
}
