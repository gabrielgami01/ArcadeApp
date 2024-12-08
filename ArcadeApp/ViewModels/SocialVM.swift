import SwiftUI

@Observable
final class SocialVM {
    let repository: RepositoryProtocol
    
    var following: [UserConnections] = []
    var followers: [UserConnections] = []
    
    var followingSessions: [Session] = []
    
    var selectedUser: User? = nil
    var userBadges: [Badge] = []
    
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
                showError = true
            }
            print(error.localizedDescription)
        }
    }
    
    func isFollowed(userID: UUID) -> Bool {
        following.contains { $0.user.id == userID }
    }
    
    func followUserAPI(id: UUID) async -> Bool {
        do {
            try await repository.followUser(id: id)
            return true
        } catch {
            await MainActor.run {
                showError = true
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
                showError = true
            }
            print(error.localizedDescription)
            return false
        }
    }
    
    func unfollowUser(id: UUID) {
        following.removeAll(where: { $0.user.id == id })
    }
    
    func getFollowingActiveSessions() async {
        do {
            let followingSessions = try  await repository.getFollowingActiveSession()
            await MainActor.run {
                self.followingSessions = followingSessions
            }
        } catch {
            await MainActor.run {
                showError = true
            }
            print(error.localizedDescription)
        }
    }
    
    func findFollowingByID(_ id: UUID) -> User? {
        guard let user = following.first(where: { $0.user.id == id })?.user else {
            return nil
        }
        return user
    }
}
