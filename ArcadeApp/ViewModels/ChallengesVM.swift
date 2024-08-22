import SwiftUI

@Observable
final class ChallengesVM {
    let interactor: DataInteractor
    
    var challenges: [Challenge] = []
    var activeType: ChallengeType = .all
    
    var emblems: [Emblem] = []
    var selectedEmblem: Emblem? = nil
    var disponibleChallenges: [Challenge] {
        challenges.filter { challenge in
            !emblems.contains { emblem in
                emblem.name == challenge.name
            }
        }
    }
    
    var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
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
    
    func getActiveEmblems() {
        Task {
            do {
                self.emblems = try await interactor.getActiveEmblems()
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func getCompletedChallenges() {
        Task {
            do {
                self.challenges = try await interactor.getCompletedChallenges()
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func addEmblem(id: UUID) {
        Task {
            do {
                let emblemDTO = CreateEmblemDTO(id: id)
                try await interactor.addEmblem(emblem: emblemDTO)
                getActiveEmblems()
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
    func deleteEmblem(id: UUID) {
        Task {
            do {
                let emblemDTO = CreateEmblemDTO(id: id)
                try await interactor.deleteEmblem(emblem: emblemDTO)
                getActiveEmblems()
            } catch {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                print(error.localizedDescription)
            }
        }
    }
}
