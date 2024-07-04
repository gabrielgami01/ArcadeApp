import SwiftUI

@Observable
final class SearchVM {
    let interactor: DataInteractor
    
    var search = ""
    var searching = false
    var games: [Game] = []
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    
    func searchGame(name: String) {
        Task {
            do {
                self.games = try await interactor.searchGame(name: name)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
