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

}
