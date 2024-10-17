import SwiftUI

@Observable
final class RegisterVM {
    let repository: RepositoryProtocol
    
    var username = ""
    var password = ""
    var fullName = ""
    var repeatPassword = ""
    var email = ""
    
    var errorMsg = ""
    var showError = false

    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
    }
    
    func register() async -> Bool {
        do {
            let newUser = CreateUserDTO(username: username, password: password, email: email, fullName: fullName)
            try await repository.register(user: newUser)
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
    
    func resetRegister() {
        username = ""
        password = ""
        repeatPassword = ""
        email = ""
        fullName = ""
    }
    
    func checkEmptyFields() -> Bool {
        !(!username.isEmpty && !password.isEmpty && !repeatPassword.isEmpty && !email.isEmpty && !fullName.isEmpty)
    }
    
    
    func checkFields() -> Bool {
        emailValidation(email) && usernameValidation(username) && passwordValidation(password) && repeatPasswordValidation(repeatPassword)
    }
    
    func emailValidation(_ email: String) -> Bool {
        let emailRegex = #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#
        
        do {
            let regex = try Regex(emailRegex)
            if let _ = try regex.wholeMatch(in: email) {
             return true
            } else {
                errorMsg = "Email is not valid."
                return false
            }
        } catch {
            errorMsg = "Email is not valid."
            return false
        }
    }
    
    func usernameValidation(_ username: String) -> Bool {
        if username.count >= 6 {
            return true
        } else {
           errorMsg = "Username cannot be less than 6 characters."
            return false
        }
    }
    
    func passwordValidation(_ password: String) -> Bool {
        let passwordRegex = #"^[a-zA-Z0-9]*$"#
        
        if password.count < 8 {
            errorMsg =  "Password cannot be less than 8 characters."
            return false
        }
        
        do {
            let regex = try Regex(passwordRegex)
            if let _ = try regex.wholeMatch(in: password) {
               return true
            } else {
                errorMsg = "Password must contain only alphanumeric characters."
                return false
            }
        } catch {
            errorMsg = "Password is not valid"
            return false
        }
    }
    
    func repeatPasswordValidation(_ repeatPassword: String) -> Bool {
        if repeatPassword != password {
            errorMsg = "Passwords must match"
            return false
        } else {
            return true
        }
    }
}
