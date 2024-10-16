import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: UUID
    let email: String
    let username: String
    let fullName: String
    let about: String?
    let avatarImage: Data?
}

struct UserDTO: Codable {
    let userID: UUID
}

struct CreateUserDTO: Codable {
    let username: String
    let password: String
    let email: String
    let fullName: String
}

struct LoginDTO: Codable {
    let token: String
    let user: User
}

struct UpdateUserDTO: Codable {
    let about: String?
    let imageData: Data?
}



