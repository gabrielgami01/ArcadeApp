import SwiftUI

@Observable
final class AddScoreVM {
    
    var image: UIImage?
    
    var errorMsg = ""
    var showError = false

    
    func newScore() -> (score: Score, image: Data)? {
        if let image, let data = image.jpegData(compressionQuality: 0.8) {
            let score = Score(id: UUID(), score: nil, state: .unverified, date: .now)
            return (score, data)
        } else {
            return nil
        }
    }
}
