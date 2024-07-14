import SwiftUI

@Observable
final class AddScoreVM {
    let interactor: DataInteractor
    
    var selectedGame: Game?
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
}
