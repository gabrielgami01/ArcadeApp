import SwiftUI

@Observable
final class SearchVM {
    let interactor: DataInteractor
    
    var consoles: [Console] = []
    var genres: [Genre] = []

    var games: [Game] = []
    
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
    
    func getGamesByGenreConsole(item: Master) async {
        do {
            if item is Console {
               let games = try await interactor.getGamesByConsole(id: item.id)
                self.games = games
            } else if item is Genre {
               let games = try await interactor.getGamesByGenre(id: item.id)
                self.games = games
            }
        } catch {
            self.errorMsg = error.localizedDescription
            self.showAlert.toggle()
            print(error.localizedDescription)
        }
    }
}
