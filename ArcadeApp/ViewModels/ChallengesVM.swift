import SwiftUI

@Observable
final class ChallengesVM {
    let interactor: DataInteractor
    
    var challenges: [Challenge] = []
    var activeType: ChallengeType = .all {
        didSet {
            activeType != oldValue ? challenges.removeAll() : nil
            page = 1
        }
    }
    
    var page = 1
    
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
                    self.challenges += try await interactor.getAllChallenges(page: page)
                } else {
                    self.challenges += try await interactor.getChallengesByType(type: type.rawValue, page: page)
                }
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func isLastItem(_ challenge: Challenge) {
        if challenges.last?.id == challenge.id {
            page += 1
            getChallenges(type: activeType)
        }
    }
}
