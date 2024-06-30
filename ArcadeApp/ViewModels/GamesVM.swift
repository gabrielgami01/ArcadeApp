import SwiftUI

@Observable
final class GamesVM {
    let interactor: DataInteractor
    
    var featured: [Game] = []
    var favorites: [Game] = []
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        if SecManager.shared.isLogged {
            Task { await getFeaturedFavoriteGames() }
        }
        NotificationCenter.default.addObserver(forName: .login, object: nil, queue: .main) { _ in
            Task { await self.getFeaturedFavoriteGames() }
        }
    }
    
    func getFeaturedFavoriteGames() async {
        do {
            (featured, favorites) = try await interactor.getFeaturedFavoriteGames()
        } catch {
            print(error.localizedDescription)
        }
    }
}
