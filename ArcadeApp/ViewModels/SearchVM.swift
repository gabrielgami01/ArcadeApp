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
            (self.consoles, self.genres) = try await interactor.getConsolesGenres()
        } catch {
            self.errorMsg = error.localizedDescription
            self.showAlert.toggle()
            print(error.localizedDescription)
        }
    }
    
    func getGamesByMaster(master: Master) async {
        do {
            self.games = try await interactor.getGamesByMaster(master: master)
        } catch {
            self.errorMsg = error.localizedDescription
            self.showAlert.toggle()
            print(error.localizedDescription)
        }
    }
}
