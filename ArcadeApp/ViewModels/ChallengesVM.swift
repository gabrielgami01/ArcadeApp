import SwiftUI

@Observable
final class ChallengesVM {
    let interactor: DataInteractor
    
    var challenges: [Challenge] = []
    var activeType: ChallengeType = .all
    @ObservationIgnored var filteredChallenges: [Challenge] {
        if activeType != .all {
            challenges.filter{ $0.type == activeType}
        } else {
            challenges
        }
    }
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    func getChallenges() async {
        do {
            challenges = try await interactor.getAllChallenges()
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
        }
    }
}
