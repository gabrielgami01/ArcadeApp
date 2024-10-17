import SwiftUI

@Observable
final class ChallengesVM {
    let repository: RepositoryProtocol
    
    var challenges: [Challenge] = []
    var searchText = ""
    var sortOption: SortOption = .completed
    @ObservationIgnored var displayChallenges: [Challenge] {
        challenges.filter { challenge in
            if searchText.isEmpty {
                true
            } else {
                challenge.game.localizedStandardContains(searchText) || challenge.name.localizedStandardContains(searchText)
            }
        }
        .sorted { c1, c2 in
            switch sortOption {
                case .completed:
                    !c1.isCompleted && c2.isCompleted
                case .uncompleted:
                    c1.isCompleted && !c2.isCompleted
            }
        }
    }
    
    var emblems: [Emblem] = []
    @ObservationIgnored var completedChallenges: [Challenge] {
        challenges.filter{ $0.isCompleted }
    }
    @ObservationIgnored var disponibleChallenges: [Challenge] {
        completedChallenges.filter { challenge in
            !emblems.contains { emblem in
                emblem.challenge.id == challenge.id
            }
        }
    }
    
    var selectedEmblem: Emblem? = nil
    
    var errorMsg = ""
    var showError = false
    
    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
    }
    
    func getChallenges() async {
        do {
            let challenges = try await repository.getChallenges()
            await MainActor.run {
                self.challenges = challenges
            }
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func getUserEmblems(id: UUID? = nil) async {
        do {
            if let id {
                let emblems = try await repository.getUserEmblems(id: id)
                await MainActor.run {
                    self.emblems = emblems
                }
            } else {
                let emblems = try await repository.getActiveUserEmblems()
                await MainActor.run {
                    self.emblems = emblems
                }
            }
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func addEmblemAPI(challengeID: UUID) async -> Bool {
        do {
            let emblemDTO = CreateEmblemDTO(challengeID: challengeID)
            try await repository.addEmblem(emblemDTO)
            return true
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
            return false
        }
    }
    
    func addEmblem(_ emblem: Emblem) {
        emblems.append(emblem)
    }
    
    func updateEmblemAPI(newChallenge: UUID, oldChallenge: UUID) async -> Bool {
        do {
            let createEmblemDTO = CreateEmblemDTO(challengeID: newChallenge)
            try await repository.deleteEmblem(challengeID: oldChallenge)
            try await repository.addEmblem(createEmblemDTO)
            return true
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
            return false
        }
    }
    
    func updateEmblem(_ emblem: Emblem) {
        if let index = emblems.firstIndex(where: { $0.id == emblem.id}) {
            emblems[index] = emblem
        }
    }
}
