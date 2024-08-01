import SwiftUI

@Observable
final class AddScoreVM {
    let interactor: DataInteractor
    
    let game: Game
    var image: UIImage?
    
    var showCamera = false
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared, game: Game) {
        self.interactor = interactor
        self.game = game
    }
    
    func addScore() {
        Task {
            do {
                if let image, let data = image.jpegData(compressionQuality: 0.8) {
                    let score = CreateScoreDTO(image: data, gameID: game.id)
                    try await interactor.addScore(score: score)
                    NotificationCenter.default.post(name: .details, object: nil)
                }
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
}
