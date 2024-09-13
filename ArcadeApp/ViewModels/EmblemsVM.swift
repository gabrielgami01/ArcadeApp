import SwiftUI

@Observable
final class EmblemsVM {
    let interactor: DataInteractor
    
    var completedChallenges: [Challenge] = []
    var emblems: [Emblem] = []
    var selectedEmblem: Emblem? = nil
    @ObservationIgnored var disponibleChallenges: [Challenge] {
        completedChallenges.filter { challenge in
            !emblems.contains { emblem in
                emblem.challenge.id == challenge.id
            }
        }
    }
    
    var selectedUser: User?
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    func getUserEmblems(id: UUID? = nil) async {
        do {
            if let id {
                emblems = try await interactor.getUserEmblems(id: id)
            } else {
                emblems = try await interactor.getActiveUserEmblems()
            }
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
        }
    }
    
    func getCompletedChallenges() async {
        do {
            completedChallenges = try await interactor.getCompletedChallenges()
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
        }
    }
    
    func addEmblem(challengeID: UUID) {
        Task {
            do {
                let emblemDTO = EmblemDTO(challengeID: challengeID)
                try await interactor.addEmblem(emblemDTO)
                await getUserEmblems()
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func updateEmblem(id: UUID, challengeID: UUID) async -> Bool {
        do {
            let emblemDTO = EmblemDTO(challengeID: challengeID)
            try await interactor.updateEmblem(id: id, emblemDTO: emblemDTO)
            return true
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error.localizedDescription)
            return false
        }
    }
}
