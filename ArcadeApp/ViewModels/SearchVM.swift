import SwiftUI

@Observable
final class SearchVM {
    let interactor: DataInteractor
    
    var search: String = "" {
        didSet {
            page = 1
        }
    }
    var searching = false
    var games: [Game] = []
    
    var page = 1
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    
    func searchGame(name: String) {
        Task {
            do {
                self.games = try await interactor.searchGame(name: name, page: page)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
