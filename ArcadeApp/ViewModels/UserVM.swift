import SwiftUI

@Observable
final class UserVM {
    let interactor: DataInteractor
    let secManager: SecManager = SecManager.shared
    
    var isLogged = false
    var showSignup = false
    
    var activeUser: User? = nil
    var about: String = ""
    
    var username = ""
    var password = ""
    var fullName = ""
    var repeatPassword = ""
    var email = ""
    
    var errorMsg = ""
    var showError = false
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        self.isLogged = secManager.isLogged
        if isLogged {
            getUserInfo()
        }
    }
    
    func login() {
        Task {
            do {
                self.activeUser = try await interactor.loginJWT(user:username, pass:password)
                isLogged.toggle()
            } catch {        
                print(error)
            }
        }
    } 
    
    func getUserInfo() {
        Task {
            do {
                self.activeUser = try await interactor.getUserInfo()
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
    
    func fullNameValidation(value: String) -> String? {
        if value.isEmpty {
            "cannot be empty"
        } else {
            nil
        }
    }
    
    func emailValidation(value: String) -> String? {
        let emailRegex = #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#
        do {
            let regex = try Regex(emailRegex)
            return if let _ = try regex.wholeMatch(in: value) {
                nil
            } else {
                "is not valid"
            }
        } catch {
            return "is not valid"
        }
    }
    
    func usernameValidation(value: String) -> String? {
        if value.isEmpty {
            "cannot be empty"
        } else if value.count < 6 {
            "cannot be greater than 6 characters"
        } else {
            nil
        }
    }
    
    func passwordValidation(value: String) -> String? {
        let passwordRegex = #"^[a-zA-Z0-9]*$"#
        
        if value.isEmpty {
            return "cannot be empty"
        } else if value.count < 8 {
            return "cannot be less than 8 characters"
        }
        
        do {
            let regex = try Regex(passwordRegex)
            if let _ = try regex.wholeMatch(in: value) {
                return nil
            } else {
                return "must contain only alphanumeric characters"
            }
        } catch {
            return "Validation error"
        }
    }
    
    func repeatPasswordValidation(value: String) -> String? {
        if value != password {
            "must match"
        } else {
            nil
        }
    }
    
    func enableSignupButton() -> Bool {
        !(!username.isEmpty && !password.isEmpty && !repeatPassword.isEmpty && !email.isEmpty && !fullName.isEmpty && !showError)
    }
    
    func editUserAbout() {
        Task {
            do {
                try await interactor.editUserAbout(about: EditUserAboutDTO(about: about))
                getUserInfo()
            } catch {
                print(error)
            }
        }
    }
    
}
