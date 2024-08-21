import SwiftUI

@Observable
final class ChallengesVM {
    let interactor: DataInteractor
    
    var challenges: [Challenge] = []
    var activeType: ChallengeType = .all
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        getChallenges()
    }
    
    func getChallenges(type: ChallengeType = .all) {
        Task {
            do {
                if type == .all {
                    self.challenges = try await interactor.getAllChallenges()
                } else {
                    self.challenges = try await interactor.getChallengesByType(type)
                }
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }

}
