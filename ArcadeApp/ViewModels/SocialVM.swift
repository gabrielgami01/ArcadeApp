import SwiftUI

@Observable
final class SocialVM {
    let interactor: DataInteractor
    
    var following: [UserFollows] = []
    var followers: [UserFollows] = []
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        if SecManager.shared.isLogged {
            getFollowingFollowers()
        }
        NotificationCenter.default.addObserver(forName: .login, object: nil, queue: .main) { [self] _ in
            getFollowingFollowers()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .login, object: nil)
    }
    
    func getFollowingFollowers() {
        Task(priority: .high) {
            do {
                (following, followers) = try await interactor.getFollowingFollowers()
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func followUser(userID: UUID) {
        Task {
            do {
                let userDTO = UserDTO(id: userID)
                try await interactor.followUser(userDTO)
                getFollowingFollowers()
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func unfollowUser(userID: UUID) {
        Task {
            do {
                try await interactor.unfollowUser(id: userID)
                getFollowingFollowers()
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func isFollowed(userID: UUID) -> Bool {
        let result = following.contains { $0.user.id == userID }
        print(result)
        return result
    }
}
