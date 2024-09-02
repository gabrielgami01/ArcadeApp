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
        scores.filter { $0.state == .verified }
    }
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        NotificationCenter.default.addObserver(forName: .details, object: nil, queue: .main) { [self] notification in
            if let userInfo = notification.userInfo, let id = userInfo["gameID"] as? UUID {
                Task {
                    await getGameDetails(id: id)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .details, object: nil)
    }
    
    
    func getGameDetails(id: UUID) async {
        do {
            (isFavorite, reviews, scores) = try await interactor.getGameDetails(id: id)
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
        }
    }
    
    func useFavorite(id: UUID) {
        Task {
            do {
                let favoriteDTO = FavoriteGameDTO(id: id)
                if isFavorite {
                    try await interactor.removeFavoriteGame(favoriteDTO)
                } else {
                    try await interactor.addFavoriteGame(favoriteDTO)
                }
                isFavorite.toggle()
                NotificationCenter.default.post(name: .favorite, object: nil)
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
}
