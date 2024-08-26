import Foundation

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

struct User: Codable {
    let id: UUID
    let email: String
    let username: String
    let fullName: String
    let biography: String?
    let avatarImage: Data?
}

struct EditUserAboutDTO: Codable {
    let about: String
}

struct EditUserAvatarDTO: Codable {
    let image: Data
}
