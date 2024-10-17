import SwiftUI

@Observable
final class SocialVM {
    let repository: RepositoryProtocol
    
    var following: [UserConnections] = []
    var followers: [UserConnections] = []
    
    var errorMsg = ""
    var showError = false
    
    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
        if SecManager.shared.isLogged {
            Task(priority: .high) {
                await getFollowingFollowers()
            }
        }
        NotificationCenter.default.addObserver(forName: .login, object: nil, queue: .main) { [self] _ in
            Task(priority: .high) {
                await getFollowingFollowers()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .login, object: nil)
    }
    
    func getFollowingFollowers() async {
        do {
            let (following, followers) = try await repository.getFollowingFollowers()
            await MainActor.run {
                self.following = following
                self.followers = followers
            }
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func isFollowed(userID: UUID) -> Bool {
        following.contains { $0.user.id == userID }
    }
    
    func followUserAPI(id: UUID) async -> Bool {
        do {
            let connectionsDTO = UserDTO(userID: id)
            try await repository.followUser(connectionsDTO)
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
    
    func followUser(_ userConnections: UserConnections) {
        following.append(userConnections)
    }
    
    func unfollowUserAPI(id: UUID) async -> Bool {
        do {
            try await repository.unfollowUser(id: id)
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
    
    func unfollowUser(id: UUID) {
        following.removeAll(where: { $0.user.id == id })
    }
    
}
