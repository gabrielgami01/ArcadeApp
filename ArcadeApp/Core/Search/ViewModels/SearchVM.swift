import SwiftUI

@Observable
final class SearchVM {
    let interactor: SearchInteractorProtocol
    
    var consoles: [Console] = []
    var genres: [Genre] = []

    var games: [Game] = []
    
    var search = ""
    var searching = false
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: SearchInteractorProtocol = SearchInteractor.shared) {
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
    
    func getGamesByGenreConsole(item: GenreConsole) async {
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
