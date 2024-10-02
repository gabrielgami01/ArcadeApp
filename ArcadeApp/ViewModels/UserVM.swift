import SwiftUI
import PhotosUI

@Observable
final class UserVM {
    let interactor: DataInteractor
    let secManager: SecManager = SecManager.shared
    
    var activeUser: User? = nil
    
    var about: String = ""

    var photoItem: PhotosPickerItem? {
        didSet {
            Task { await updateUserAvatar() }
        }
    }
    
    var username = ""
    var password = ""

    var errorMsg = ""
    var showError = false

    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        
        if secManager.isLogged {
            Task { await refreshToken() }
        }
    }
    
    func login() async {
        do {
            let activeUser = try await interactor.login(user: username, pass: password)
            await MainActor.run {
                self.activeUser = activeUser
            }
            NotificationCenter.default.post(name: .login, object: nil)
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func logout() {
        if let username = activeUser?.username {
            self.username = username
        }
        activeUser = nil
        secManager.logout()
    }
    
    func refreshToken() async {
        do {
            let activeUser = try await interactor.refreshJWT()
            await MainActor.run {
                self.activeUser = activeUser
            }
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func updateUserAboutAPI() async -> Bool {
        do {
            let updateUserDTO = UpdateUserDTO(about: about, imageData: nil)
            try await interactor.updateUserAbout(updateUserDTO)
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
    
    func updatedUserAbout() {
        guard let user = activeUser else {
            return
        }
        
        let updatedUser = User(id: user.id,
                               email: user.email,
                               username: user.username,
                               fullName: user.fullName,
                               about: about,
                               avatarImage: user.avatarImage)
        activeUser = updatedUser
    }
    
    func updateUserAvatar() async {
        do {
            if let imageData = try await convertPhotoItem() {
                let updateUserDTO = UpdateUserDTO(about: nil, imageData: imageData)
                try await interactor.updateUserAvatar(updateUserDTO)
                updateUserAvatar(imageData: imageData)
            }
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func updateUserAvatar(imageData: Data) {
        guard let user = activeUser else {
            return
        }
        
        let updatedUser = User(id: user.id,
                               email: user.email,
                               username: user.username,
                               fullName: user.fullName,
                               about: user.about,
                               avatarImage: imageData)
        activeUser = updatedUser
    }
    
    func resetLogin() {
        username = ""
        password = ""
    }
    
    func checkEmptyFields() -> Bool {
        !(!username.isEmpty && !password.isEmpty)
    }
    
    func convertPhotoItem() async throws -> Data? {
        guard let photoItem else { return nil }
        
        if let result = try await photoItem.loadTransferable(type: Data.self),
           let image = UIImage(data: result),
           let resize = await image.byPreparingThumbnail(ofSize: image.size.thumbnailCGSize(width: 100, height: 100)),
           let data = resize.heicData() {
            return data
        } else {
            return nil
        }
    }
    
}
