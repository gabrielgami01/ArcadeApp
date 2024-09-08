import SwiftUI
import PhotosUI

@Observable
final class UserVM {
    let interactor: DataInteractor
    let secManager: SecManager = SecManager.shared
    
    var isLogged = false
    var activeUser: User? = nil
    var about: String = ""
    var photoItem: PhotosPickerItem? {
        didSet {
            editUserAvatar()
        }
    }
    
    var username = ""
    var password = ""

    var errorMsg = ""
    var showError = false

    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        isLogged = secManager.isLogged
        if isLogged {
            refreshToken()
        }
    }
    
    func login() {
        Task {
            do {
                activeUser = try await interactor.loginJWT(user: username, pass: password)
                isLogged.toggle()
                password = ""
            } catch {
                errorMsg = error.localizedDescription
                showError = true
                print(error)
            }
        }
    }
    
    func refreshToken() {
        Task {
            do {
                activeUser = try await interactor.refreshJWT()
            } catch {
                errorMsg = error.localizedDescription
                showError = true
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserInfo() {
        Task {
            do {
                activeUser = try await interactor.getUserInfo()
            } catch {
                errorMsg = error.localizedDescription
                showError = true
                print(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        secManager.logout()
        isLogged.toggle()
    }
    
    func resetLogin() {
        username = ""
        password = ""
    }
    
    func checkEmptyFields() -> Bool {
        !(!username.isEmpty && !password.isEmpty)
    }
    
    func editUserAvatar() {
        Task {
            guard let photoItem else { return }
            
            if let result = try await photoItem.loadTransferable(type: Data.self),
               let image = UIImage(data: result),
               let resize = await image.byPreparingThumbnail(ofSize: image.size.thumbnailCGSize(width: 100, height: 100)),
               let data = resize.heicData() {
                let avatarDTO = EditUserAvatarDTO(image: data)
                try await interactor.editUserAvatar(avatarDTO)
                getUserInfo()
            } else {
                print("Error updating user's avatar")
            }
        }
    }
    
    func editUserAbout() {
        Task {
            do {
                let aboutDTO = EditUserAboutDTO(about: about)
                try await interactor.editUserAbout(aboutDTO)
                getUserInfo()
            } catch {
                print(error)
            }
        }
    }
    
}
