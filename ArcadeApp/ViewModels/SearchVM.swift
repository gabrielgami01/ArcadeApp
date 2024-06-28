import SwiftUI

@Observable
final class SearchVM {
    let interactor: DataInteractor
    
    var consoles: [Console] = []
    var genres: [Genre] = []

    var games: [Game] = []
    var selectedGame: Game? = nil
    
    var search = ""
    var searching = false
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        Task {
            await getConsolesGenres()
        }
    }
    
    func getConsolesGenres() async {
        do {
            let (consoles, genres) = try await interactor.getConsolesGenres()
            self.consoles = consoles
            self.genres = genres
        } catch {
            self.errorMsg = error.localizedDescription
            self.showAlert.toggle()
            print(error.localizedDescription)
        }
    }
    
    func getGamesByMaster(master: Master) async {
        do {
            let games = try await interactor.getGamesByMaster(master: master)
            self.games = games
        } catch {
            self.errorMsg = error.localizedDescription
            self.showAlert.toggle()
            print(error.localizedDescription)
        }
    }
}
