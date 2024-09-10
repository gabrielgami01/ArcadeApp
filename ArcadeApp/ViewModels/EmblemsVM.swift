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
                emblem.name == challenge.name
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
    
    func addEmblem(id: UUID) {
        Task {
            do {
                let emblemDTO = CreateEmblemDTO(id: id)
                try await interactor.addEmblem(emblemDTO)
                await getUserEmblems()
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
                await getUserEmblems()
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
}