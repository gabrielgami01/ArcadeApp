import SwiftUI

@Observable
final class AddScoreVM {
    let interactor: DataInteractor
    
    let game: Game
    var image: UIImage?
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared, game: Game) {
        self.interactor = interactor
        self.game = game
    }
}
