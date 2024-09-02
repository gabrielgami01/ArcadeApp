import SwiftUI

@Observable
final class AddScoreVM {
    let interactor: DataInteractor
    
    let game: Game
    var image: UIImage?
    
    var showCamera = false
    
    var errorMsg = ""
    var showError = false
    
    init(game: Game, interactor: DataInteractor = Network.shared) {
        self.game = game
        self.interactor = interactor
    }
    
    func addScore() {
        Task {
            do {
                if let image, let data = image.jpegData(compressionQuality: 0.8) {
                    let scoreDTO = CreateScoreDTO(image: data, gameID: game.id)
                    try await interactor.addScore(scoreDTO)
                    NotificationCenter.default.post(name: .details, object: nil)
                }
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
}
