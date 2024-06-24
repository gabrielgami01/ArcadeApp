import SwiftUI

@Observable
final class LoginVM {
    let interactor: LoginInteractorProtocol
    let secManager: SecManager = SecManager.shared
    
    var isLogged = false
    var showSignup = false
    
    var username = ""
    var password = ""
    var fullName = ""
    var repeatPassword = ""
    var email = ""
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: LoginInteractor = LoginInteractor.shared) {
        self.interactor = interactor
        self.isLogged = secManager.isJWTToken
    }
    
    func login() {
        Task {
            do {
                try await interactor.loginJWT(user:username, pass:password)
                isLogged.toggle()
            } catch {        
                print(error)
            }
        }
    } 
    
    func logout() {
        secManager.logout()
        isLogged.toggle()
    }
    
    func register() {
        Task {
            do {
                let newUser = CreateUserDTO(username: username, password: password, email: email, fullName: fullName)
                try await interactor.createUser(user: newUser)
                password = ""
                showSignup.toggle()
            } catch {
                print(error)
            }
        }
    }
    
    func resetRegister() {
        username = ""
        password = ""
        repeatPassword = ""
        email = ""
        fullName = ""
    }
    
}
