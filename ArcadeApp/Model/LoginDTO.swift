import Foundation

struct CreateUserDTO: Codable {
    let username: String
    let password: String
    let email: String
    let fullName: String
}

struct TokenDTO: Codable {
    let token: String
}
