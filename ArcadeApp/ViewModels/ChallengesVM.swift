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
    
    var emblems: [Emblem] = []
    var selectedEmblem: Emblem? = nil
    @ObservationIgnored var disponibleChallenges: [Challenge] {
        challenges.filter { challenge in
            !emblems.contains { emblem in
                emblem.name == challenge.name
            }
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
    
    func getActiveEmblems() async {
        do {
            emblems = try await interactor.getActiveEmblems()
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
        }
    }
    
    func getCompletedChallenges() async {
        do {
            challenges = try await interactor.getCompletedChallenges()
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
        }
    }
    
    func addEmblem(id: UUID) {
        Task {
            do {
                let emblemDTO = CreateEmblemDTO(id: id)
                try await interactor.addEmblem(emblemDTO)
                await getActiveEmblems()
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteEmblem(id: UUID) {
        Task {
            do {
                let emblemDTO = CreateEmblemDTO(id: id)
                try await interactor.deleteEmblem(emblemDTO)
                await getActiveEmblems()
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
}
